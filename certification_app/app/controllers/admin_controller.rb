class AdminController < ApplicationController

  def all
    if not Admin.where(hashed_id: params[:hashed_id]).exists?
      redirect_to root_url
    end
    @admin = Admin.find(params[:hashed_id])
    @courses = Course.all.select{ |course| not course.accepted }
  end

  def submit
    courses_accepted = params[:courses_accepted][:id]
    courses_accepted.select!{ |v| v.to_i != 0 }

    @admin = Admin.find(params[:hashed_id])

    courses_accepted.each do |id|
      course = Course.find(id)
      inst_cert = InstCert.new(user_id: course.user[:public_addr], course_id: course[:id], desc: "You are a instructor now!")
      inst_cert.save

      hash = Digest::MD5.new
      hash << inst_cert.to_json
      hash = hash.hexdigest
      tx_hash = registerCourse(@admin, course.user[:public_addr], hash, course[:id]+1000)

      inst_cert.update(transaction_hash: tx_hash)
      course.update(accepted: true, accepted_time: DateTime.now, )
    end

    redirect_to root_url
  end

  private
    
    def registerCourse(admin, inst_addr, hash, courseNo)
      arg1 = "0x" + @admin.private_key
      arg2 = "0x" + @admin.public_addr
      arg3 = "0x" + inst_addr
      arg4 = "0x" + @admin.contract_addr
      arg5 = hash
      arg6 = courseNo

      python_script = Rails.root.join('python_scripts/deployCourseContract.py')
      result = `python #{python_script} #{arg1} #{arg2} #{arg3} #{arg4} #{arg5} #{arg6}`
      return result
    end

end
