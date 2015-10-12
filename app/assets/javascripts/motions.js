// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
(function(){

  var Motion = function(){
    if ($('#controller-motions').length > 0) {
      this.init(); 
    }
  };

  /**
   * Initializing the motion javascript
   */
  Motion.prototype.init = function() {
    console.log('here');
    this.bindAddOptionSubmit();
  };

  Motion.prototype.bindAddOptionSubmit = function() {
    var $optionsContainer = $('.js-options-container');
    $('.js-add-option-form').on('submit', function(e){
      e.preventDefault();
      var $form = $(this);
      var submitData = {};
      submitData.id = $form.find('.js-motion-id').val();
      submitData.title = $form.find('.js-motion-title').val();
      console.log(submitData);
      $.ajax({
        dataType: 'json',
        type: 'post',
        data: submitData,
        success: function(data) {
          // append new data to form
          if (data && data.success) {
            $optionsContainer.append(data.html);
          }
          // clear form
          $form.find('.js-motion-title').val('');
        }

      })
    });
  };


  var motion = new Motion();
}());