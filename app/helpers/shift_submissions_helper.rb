module ShiftSubmissionsHelper
  def forms_num
    case @branch.subtype
    when Weekly
      case @branch.subtype.num_of_weeks
      when 1 then { default: 4, max: 7 }
      when 2 then { default: 7, max: 14 }
      end
    when Monthly
      case @branch.subtype.period_num
      when 1 then { default: 15, max: 31 }
      when 2 then { default: 8, max: 16 }
      end
    end
  end
end
