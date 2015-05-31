module RatingsHelper

  def ratings_question(num, question)
    label_for("#{num}. #{question}")
  end
end
