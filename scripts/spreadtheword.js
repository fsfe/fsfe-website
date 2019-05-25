// This file contains JavaScript for the "spreadtheword" page

(function() {
    // Validate the donation field.
    // Shows a validation error if one of the following conditions match
    // - the donate field is empty
    // - the donate field value is below 10

    var form = document.getElementById('orderpromo');
    var donationAmountInput = document.getElementById('donate');
    var donationErrorElement = document.getElementById('donate-error');
    var donateGroup = document.getElementById('donate-group');

    /**
     * Sets the donate field to the error state.
     */
    function setDonateError() {
        donateGroup.classList.add('has-error');
        donationErrorElement.style.display = 'block';
    }

    form.addEventListener('submit', function (event) {
        var value = donationAmountInput.value.trim();

        if (value !== '') {
            var parsedValue = parseInt(value, 10);

            if (parsedValue > 0 && parsedValue < 10) {
                setDonateError();
                event.preventDefault();
            }
        }
    });
})();
