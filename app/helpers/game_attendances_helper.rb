module GameAttendancesHelper

  def attendance_class(attendance)
    is_attending_class = nil
    if !attendance.nil?
      is_attending = attendance.is_attending
      if is_attending
        is_attending_class = 'is-attending'
      else
        is_attending_class = 'is-not-attending'
      end
    end
    is_attending_class
  end
end
