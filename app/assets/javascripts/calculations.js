jQuery(function($) {
  var addConstraint = function(e) {
    var template = $('[id=constraint-template]').clone();
    var newConstraint = template[0].children[0];
    var newIndex = $('[id=constraints]').children().length;

    newConstraint.children[1].children[0].id = 'calculations_constraint_' + newIndex + '_amount';
    newConstraint.children[2].children[0].id = 'calculations_constraint_' + newIndex + '_color';
    newConstraint.children[4].children[0].id = 'calculations_constraint_' + newIndex + '_turn';

    newConstraint.children[1].children[0].name = 'calculations[constraint_' + newIndex + '][amount]';
    newConstraint.children[2].children[0].name = 'calculations[constraint_' + newIndex + '][color]';
    newConstraint.children[4].children[0].name = 'calculations[constraint_' + newIndex + '][turn]';

    $('[id=constraints]')[0].appendChild(newConstraint);

    return false;
  };

  var redisplayNonBasicLands = function() {
    var colorsToKeep = [];
    var colorSelectElements = $('[id*=_color]');
    var allColors = ['white', 'blue', 'black', 'red', 'green', 'colorless'];

    for (var i = 0, len = colorSelectElements.length; i < len; i++) {
      colorsToKeep.push(colorSelectElements[i].value);
    };

    colorsToKeep.pop(); // Discard the template's color, which defaults to white.

    for (var i = 0, len = allColors.length; i < len; i++) {
      var color = allColors[i];
      var element = $("[id*=" + color + "]");

      if (keepColor(colorsToKeep, color)) {
        element.show();
        element.parent().css("display", "block");
      } else {
        element.hide();
        element.parent().css("display", "none");
      }
    };
  };

  var keepColor = function(colorsToKeep, color) {
    return ~colorsToKeep.indexOf(color);
  };

  var watchAndUpdateConstraints = function() {
    $(document).on('click', '#add-constraint', function(e) {
      addConstraint(e);
    });
  };

  var watchAndUpdateNonBasicLands = function() {
    $(document).on('change', '[id*=_color]', function(e) {
      redisplayNonBasicLands();
    });
  };


  watchAndUpdateConstraints();
  watchAndUpdateNonBasicLands();
});
