jQuery(function($) {
  var addConstraint = function() {
    var template = $('[id=constraint-template]').clone();
    var newConstraint = template[0].children[0];

    $('[id=constraints]')[0].appendChild(newConstraint);

    return false;
  };

  var watchAndUpdateConstraints = function() {
    $(document).on('click', '#add-constraint', function() {
      addConstraint();
    });
  };

  watchAndUpdateConstraints();
});
