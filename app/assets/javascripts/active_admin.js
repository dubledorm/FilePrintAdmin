//= require active_admin/base

function select_output_type(value) {
    if (value == 'pdf') {
        document.getElementById("input_options").style.display = 'block';
        document.getElementById("input_margins").style.display = 'block';
    } else {
        document.getElementById("input_options").style.display = 'none';
        document.getElementById("input_margins").style.display = 'none';
    }
}

