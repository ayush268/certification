module CoursesHelper


  def course_status(course)

    # Periods are assumed in hours
    registration_period = 24
    course_period = registration_period + 48

    hours_elapsed = (DateTime.now.to_i - course.accepted_time.to_i) / 3600
    case true
      when hours_elapsed < registration_period
        return "Registration Period"
      when hours_elapsed < course_period
        return "Course Ongoing"
      else
        return "Course Completed"
    end

  end


end
