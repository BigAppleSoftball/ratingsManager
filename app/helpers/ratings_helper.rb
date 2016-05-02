module RatingsHelper

  # connected questions
  # yes to 2 = yes to 1
  # yes to 3 = yes to 1, 2
  # yes to 4 = yes to 1, 2, 3
  # 
  # 6-14
  # 15 - 17
  # 19-21
  # 23 - 25
  def ratings_question(num, question)
    label_for("#{num}. #{question}")
  end

  def set_question(question)
    question_string = 'Does the player have the ability to... <br/>'
    if (question.size > 1)
      question.each_with_index do |q, index|
        question_string += "#{q}"
        if index != question.size - 1
          question_string += '<br><span class="text-center">OR</span><br>'
        end
      end
    else
      question_string += question.first
    end
    question_string.html_safe
  end

  def question_1
    ["occasionally throw a ball through the air 65 feet or better in the vicinity of another player? (65 feet is the distance between bases)"]
  end

  def question_2
    ['consistently throw a ball through the air 90 feet or better in the vicinity of another player?
    (90 feet is the distance between 3rd and 1st)',
      
    'occasionally throw to the proper place turning accurate infield plays against runners with average base running speed?']
  end

  def question_3
    ['occasionally throw a ball through the air 90 feet or better without a rainbow arc in the vicinity of another player?', 
      'consistently throw to the proper place turning accurate infield plays against runner with average base running speed?'] 
  end

  def question_4
    ['consistently throw a ball through the air 90 feet or better without a rainbow arc in the vicinity of another player?']
  end

  def question_5
    ['consistently throw without a rainbow arc to the proper place turning accurate infield plays against aggressive runners with above average speed?',
    'consistently make long throws without a rainbow arc from the outfield directly and accurately to the proper base completing proper plays against aggressive runners with above average speed?']
  end

  def question_6
    ['occasionally on purpose catch balls that are thrown to the player with a rainbow arc?']
  end

  def question_7
    ['occasionally on purpose catch balls that are thrown to the player without a rainbow arc?']
  end

  def question_8
    ['consistently on purpose field slow hit balls that are within a few steps?',

      'consistently on purpose catch fly balls that are within 15 feet? ']
  end

  def question_9
    ['consistently on purpose field medium hit balls that are within a few steps?',
      'consistently on purpose catch fly balls that are more than 15 feet away? ']
  end

  def question_10
    ['occasionally on purpose field medium hit balls that are in the hole?',
      'occasionally on purpose catch fly balls that are more than 30 feet away? ']
  end

  def question_11
    ['consistently on purpose field medium hit balls that are in the hole?',
      'consistently on purpose catch fly balls that are more than 30 feet away?'
    ]
  end

  def question_12
    ['occasionally on purpose field hard hit balls that are in the hole?',
      'occasionally on purpose stop line drives in the gaps from getting by the outfielders? '
    ]
  end

  def question_13
    ['consistently on purpose field hard hit balls that are in the hole?',
      'consistently on purpose stop line drives in the gaps from getting by the outfielders?']
  end

  def question_14
    ['occasionally on purpose make spectacular catches? ']
  end

  def question_15
    ['go from base to base utilizing rudimentary knowledge of the rules?']
  end

  def question_16
    ['run with average speed and occasionally take extra bases on good hits or errors against a limited level of defense? ']
  end

  def question_17
    ['run aggressively with average or better speed and occasionally take extra bases on good hits',
      'errors against an intermediate level of defense?']
  end

  def question_18
    ['run very aggressively and occasionally take extra bases on good hits or errors against an
 exceptional level of defense?']
  end

  def question_19
    ['occasionally hit a fair ball?']
  end

  def question_20
    ['consistently hit a fair ball?']
  end

  def question_21
    ['occasionally hit a fair ball with at least medium velocity?']
  end

  def question_22
    ['consistently hit a fair ball with at least medium velocity? ']
  end

  def question_23
    ['consistently reach base safely on a batted ball against a limited level of defense?',
     'occasionally reach base safely on a batted ball against an intermediate level of defense?']    
  end

  def question_24
    ['consistently reach base safely on a batted ball against an intermediate level of
defense?',
      'occasionally reach base safely on a batted ball against an exceptional level of defense?']
  end

  def question_25
    ['consistently reach base safely on a batted ball with high velocity against an intermediate level of defense', 
      'consistently reach base safely on a batted ball against an exceptional level of defense?']
  end

  def question_26
    ['consistently reach base safely on a batted ball with high velocity against an exceptional level of defense?']
  end

  def question_27
    ['occasionally hit a ball over a 300’ fence?']
  end

  def response(value)
    if value == 1 
      '1 - Yes'
    else
      '0 - No'
    end
  end

  def ratings_options
    [
      ['0 - No', 0], 
      ['1 - Yes', 1]
    ]
  end
end
