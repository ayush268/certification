class CoursesController < ApplicationController

  def all
    if not logged_in?
      redirect_to login_path
    else
      courses = Course.all.select{ |course| course.accepted }
      @courses = []
      if courses.size != 0
        @courses = courses.map do |course|
          {
            id: course.id,
            no: course.course_no,
            session: course.course_session,
            desc: course.course_desc,
            status: course_status(course),
            inst: course.user
          }
        end
      end
    end
  end

  def new
    if not logged_in?
      redirect_to login_path
    end
    @course = Course.new
  end

  def create
    if not logged_in?
      redirect_to login_path
    end
    user_id = current_user[:public_addr]
    final_params = {accepted: false, user_id: user_id}
    final_params.reverse_merge!(course_params)
    @course = Course.new(final_params)
    if @course.save
      flash[:success] = "Your course request has gone for approval!"
      redirect_to user_path(user_id)
    else
      render 'new'
    end
  end

  def show
    if not logged_in?
      redirect_to login_path
    else
      #TODO Complete this function
      @course = Course.find(params[:id])
      if not @course.accepted
        redirect_to courses_path
      end

      case inst_or_student_or_else?(@course)
        when 1
          @students = @course.user_course_mappings.map do |m|
            {
              name: m.user.name,
              username: m.user.username,
              addr: m.user.public_addr,
              status: m.accepted,
              passed: m.passed,
              email: m.user.email
            }
          @mappings = @course.user_course_mappings.select{ |x| not x.accepted }
          @accepted_mappings = @course.user_course_mappings.select{ |x| x.accepted }
          end
          render 'inst_page'
        when 2
          #TODO
        when 3
          render 'rejected_page'
        else
          render 'other_people_page'
      end

    end
  end

  def update
    if params[:commit] == "Register"
      if register_student(params[:id])
        flash[:success] = "Your course request has been sent to the instructor for approval!"
        redirect_to user_path(current_user[:public_addr])
      else
        redirect_to course_path(params[:id])
      end
    end
    if params[:commit] == "Approve Requests"
      accepted_mappings = params[:accepted_users][:id]
      accepted_mappings.select!{ |v| v.to_i != 0 }

      cert_hash_list = {}
      cert_list = {}
      accepted_mappings.each do |id|
        m = UserCourseMapping.find(id)
        cert_hash_list[id], cert_list[id] = approve_student(m)
        m.update(accepted: true)
      end

      result = getRootHash(cert_hash_list.values)
      rootHash = result['rootHash']
      tokenList = result['tokenList']

      registerstudents(rootHash, params[:private_key], "1")

      accepted_mappings.each do |id|
        m = UserCourseMapping.find(id)
        comp_cert = cert_list[id]
        hash = cert_hash_list[id]
        json_data = tokenList[hash].to_json
        comp_cert.update(transaction_hash: rootHash, tokens: json_data)
      end

      redirect_to user_path(current_user[:public_addr])
    end
    if params[:commit] == "Submit Grades"
      passed_mappings = params[:passed_users][:id]
      passed_mappings.select!{ |v| v.to_i != 0 }

      cert_hash_list = {}
      cert_list = {}
      passed_mappings.each do |id|
        m = UserCourseMapping.find(id)
        cert_hash_list[id], cert_list[id] = pass_student(m)
        m.update(passed: true)
      end

      result = getRootHash(cert_hash_list.values)
      rootHash = result['rootHash']
      tokenList = result['tokenList']

      registerstudents(rootHash, params[:private_key], "0")

      passed_mappings.each do |id|
        m = UserCourseMapping.find(id)
        accept_cert = cert_list[id]
        hash = cert_hash_list[id]
        json_data = tokenList[hash].to_json
        accept_cert.update(transaction_hash: rootHash, tokens: json_data)
      end

      redirect_to user_path(current_user[:public_addr])
    end
  end

  private

    def course_params
      params.require(:course).permit(:course_no, :course_session, :course_desc)
    end

    def inst_or_student_or_else?(course)
      if current_user[:public_addr] == course.user[:public_addr]
        return 1
      end
      users = course.user_course_mappings
      users_accepted = users.select{ |m| m.accepted }.map{ |x| x.user.public_addr }
      users_rejected = users.select{ |m| not m.accepted }.map{ |x| x.user.public_addr }
      if users_accepted.include? current_user[:public_addr]
        return 2
      elsif users_rejected.include? current_user[:public_addr]
        return 3
      end
      return 4
    end

    def register_student(course_id)
      mapping = UserCourseMapping.new(user_id: current_user[:public_addr], course_id: course_id, accepted: false, passed: false)
      if mapping.save
        return true
      else
        return false
      end
    end

    def approve_student(mapping)
      comp_cert = CompCert.new(user_id: mapping[:user_id], course_id: mapping[:course_id], desc: "Tu accept ho gaya launde")
      comp_cert.save

      hash = Digest::MD5.new
      hash << comp_cert.to_json
      hash = hash.hexdigest
      return hash, comp_cert
    end

    def pass_student(mapping)
      accept_cert = AcceptCert.new(user_id: mapping[:user_id], course_id: mapping[:course_id], desc: "Tu pass ho gaya launde")
      accept_cert.save

      hash = Digest::MD5.new
      hash << accept_cert.to_json
      hash = hash.hexdigest
      return hash, accept_cert
    end

    def getRootHash(hash_list)
      args = ""
      hash_list.each do |x|
        args = args + x + " "
      end
      python_script = Rails.root.join('python_scripts/merkle_tree.py')
      result = `python #{python_script} #{args}`
      result = JSON.parse(a)
      return result
    end

    def registerstudents(rootHash, private_key, contractAddress, accept_complete)
      key = Eth::Key.new priv: private_key
      sighash = key.personal_sign(rootHash)
      @admin = Admin.all[0]
      arg1 = "0x" + @admin.private_key
      arg2 = "0x" + @admin.public_addr
      arg3 = hash
      arg4 = sighash
      arg5 = contractAddress
      arg6 = accept_complete

      python_script = Rails.root.join('python_scripts/addRootHash.py')
      result = `python #{python_script} #{arg1} #{arg2} #{arg3} #{arg4} #{arg5} #{arg6}`
      return result
    end
end
