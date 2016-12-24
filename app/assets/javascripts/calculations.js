jQuery(function($) {
  var addConstraint = function(e) {
    var template = $('[id=constraint-template]').clone();
    var newConstraint = template[0].children[0];
    var d = new Date();
    var newIndex = d.getTime();
    var idIdentifiers = [
      'quantifier',
      'amount',
      'color',
      'turn'
    ]

    newConstraint.id = 'constraint-' + newIndex;

    idIdentifiers.forEach(setIdentifier)

    function setIdentifier(identifier, index) {
      $(newConstraint).find('[id*=_' + identifier + ']')[0].id = 'calculations_constraint_' + newIndex + '_' + identifier;
      $(newConstraint).find('[id*=_' + identifier + ']')[0].name = 'calculations[constraint_' + newIndex + '][' + identifier + ']';
    }

    $(newConstraint).find('[id*=remove-constraint-]')[0].id = 'remove-constraint-' + newIndex;

    $('[id=constraints]')[0].appendChild(newConstraint);

    return false;
  };

  var removeConstraint = function(e) {
    var constraintIndex = e.currentTarget.id.match(/-(\d+)$/)[1];;

    $("[id=constraint-" + constraintIndex + "]").remove();

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
      redisplayNonBasicLands();
    });

    $(document).on('click', 'button[id*=remove-constraint]', function(e) {
      removeConstraint(e);
      redisplayNonBasicLands();
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
