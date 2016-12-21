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

  var watchAndUpdateConstraints = function() {
    $(document).on('click', '#add-constraint', function(e) {
      addConstraint(e);
    });
  };

  watchAndUpdateConstraints();
});
