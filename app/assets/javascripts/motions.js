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
    this.bindDivisionSeasonSelectorChange();
    this.bindSelectAll();
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

  /**
   * When a User changes the selector on the "Motions eligible teams page"
   * It uses ajax to update the html of that view
   */
  Motion.prototype.bindDivisionSeasonSelectorChange = function() {
    $('.js-division-season-selector').on('change', function() {
      var updateData = {
        season_id: $(this).val()
      };
      $.ajax({
        dataType: 'json',
        url: '/getdivisionchecklist',
        type: 'get',
        data: updateData,
        success: function(data) {
          if (data && data.success) {
            $('.js-division-checklist').html(data.html);
          }
        }
      });
    });
  };

  Motion.prototype.bindSelectAll = function() {
    var self = this;
    $('.js-division-checklist').on('change', '.js-select-all-division', function() {
      var $this = $(this),
          isChecked = $(this).is(':checked'),
          $divisionContainer = $(this).closest('.js-divisions-container');

      self.setAllTeams(isChecked, $divisionContainer);

    });

    $('.js-division-checklist').on('change','.js-select-all', function() {
      console.log("here");
      var $this = $(this),
          isChecked = $(this).is(':checked'),
          $divisionsContainer = $(this).closest('.js-all-divisions-container');
      self.setAllTeams(isChecked, $divisionsContainer);
      self.setAllDivisions(isChecked);
    });
  };

  /**
   * Sets All teams as checked or unchecked
   */
  Motion.prototype.setAllTeams = function(isChecked, $container) {
    if (isChecked) {
        $container.find("input.js-team-checkbox").each(function(){
          $(this).prop('checked', true);
        });
      } else {
        $container.find("input.js-team-checkbox").each(function(){
          $(this).removeProp('checked');
        });
      }
  };

  /**
   * Sets All Divisions as Checked or Unchecked
   */
  Motion.prototype.setAllDivisions = function(isChecked){
    var $container = $('.js-all-divisions-container'),
        $text = $container.find('.js-text');
    if (isChecked) {
        $container.find("input.js-select-all-division").each(function(){
          $(this).prop('checked', true);
        });
        $text.html("Select None");
      } else {
        $container.find("input.js-select-all-division").each(function(){
          $(this).removeProp('checked');
        });
        $text.html("Select All");
      }
  };



  var motion = new Motion();
}());