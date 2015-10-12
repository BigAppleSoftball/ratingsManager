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
    this.bindAddOptionSubmit();
    this.bindDeleteOptions();
  };

  /**
   * Runs ajax call to save a new option when an option is created
   */ 
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

  /**
   * Runs ajax call to delete an option when the link is clicked
   */
  Motion.prototype.bindDeleteOptions = function() {
    $('.js-options-container').on('click', '.js-delete-option', function(e) {
      e.preventDefault();
      var $option = $(this).parent('.js-option');
      var deleteData = {
        option_id: $option.data('id')
      };

      $.ajax({
        dataType: 'json',
        type: 'delete',
        data: deleteData,
        success: function(data) {
          if (data && data.success) {
            $('.js-option-' + data.option_id).remove();
          }
        }
      });

    });
  };


  var motion = new Motion();
}());