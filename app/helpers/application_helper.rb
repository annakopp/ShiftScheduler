module ApplicationHelper

  def ability_to_array(a)
    a.instance_variable_get("@rules").collect do |rule|
      rule.instance_eval do
        {
          :base_behavior => @base_behavior,
          :subjects => @subjects.map{|subject| "ShiftScheduler.Models." + subject.to_s},
          :actions => @actions.map(&:to_s),
          :conditions => @conditions
        }
      end
    end
  end

end
