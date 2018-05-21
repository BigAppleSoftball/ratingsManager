module AsanaRatingsHelper

  def question_1
    '1. Player can throw the ball accurately from third base to first base:'
  end

  def question_2
    '2. Player can throw the ball with good speed from third base to first base:'
  end

  def question_3
    '3. Player can throw the ball accurately from the white co-ed line (150ft) in left field to second base:'
  end

  def question_4
    '4. Player can throw the ball with good speed the white co-ed (150 ft) line in left field to second base:'
  end

  def question_5
    '5. Player fields solid ground balls hit right at them:'
  end 

  def question_6
    '6. Player fields solid ground balls on the run (shows good range within 10 steps in any direction):'
  end

  def question_7
    '7. Player fields fields solid fly balls hit right at them:'
  end

  def question_8
    '8. Player fields solid fly balls on the run (shows good range within 10 steps in any direction):'
  end

  def question_9
    '9. Player dives to field balls:'
  end

  def question_10
   '10. Player catches fast balls throw to her:'
  end

  def question_11
    '11. Player hits line drives with power:'
  end

  def question_12
    '12. Player hits doubles:'
  end

  def question_13
    '13. Player hits triples:'
  end

  def question_14
    '14. Player hits homeruns:'
  end

  def question_15
    '15. Player gets on base (hits and/or walks):'
  end 

  def question_16
    '16. Player has the ability to hit to all fields:'
  end

  def question_17
    '17. Player runs the bases with good speed (can make it to first within 5 seconds):'
  end

  def question_18
    '18. Player slides effectively into bases:'
  end

  def question_19
    '19. Player runs the bases aggressively and effectively:'
  end

  def question_20
    '20. Player knows the fundamentals of her position (backing up, covering bases, knowing where to throw etc...):'
  end

  def question_21
    '21. Did the Player play on a team that won the ASANA World Series?'
  end

  def question_22
    '22. Did the player play on a team that was a runner-up in Last year\'s ASANA World Series?'
  end

  def asana_response(value)
    if (value == 0) 
      '0 - Never'
    elsif (value == 1)
      '1 - Rarely (10%)'
    elsif (value == 2)
      '2 - Sometimes (25%)'
    elsif (value == 3)
      '3 - Half the Time (50%)'
    elsif (value == 4)
      '4 - Usually (75%)'
    elsif (value == 5)
      '5 - Always (90%+)'
    end
  end

  def response_ws(value)
    if (value == 0) 
      '0 - No'
    elsif (value == 10)
      '10 - Yes'
    elsif (value == 15)
      '15 - Yes, Consecutive Year'
    end
  end

  def response_runnerup(value)
    if (value == 0)
      '0 - No'
    elsif (value == 5)
      '5 - Yes'
    end
  end

  def ratings_options
    [
      ['0 - Never (0%)', 0], 
      ['1 - Rarely (10%)', 1], 
      ['2 - Sometimes (25%)', 2], 
      ['3 - Half the Time (50%)', 3], 
      ['4 - Usually (75%)', 4], 
      ['5 - Always (90%+)', 5]
    ]
  end

end
