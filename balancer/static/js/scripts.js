
$(document).ready(function() {
    function loadConfig(filename) {
        $.getJSON(`/config/${filename}`, function(data) {
            $('#config').val(data.config);
        });
    }

    $('#config-files').change(function() {
        const filename = $(this).val();
        loadConfig(filename);
    });

    $('#update-config-btn').click(function() {
        const filename = $('#config-files').val();
        const config = $('#config').val();
        $.ajax({
            url: `/update/${filename}`,
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ config: config }),
            success: function(response) {
                alert('Configuración actualizada con éxito.');
            }
        });
    });

    $('#add-member-btn').click(function() {
        const filename = $('#config-files').val();
        const member_url = $('#member-url').val();
        $.ajax({
            url: `/add_member/${filename}`,
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ member_url: member_url }),
            success: function(response) {
                alert('Miembro agregado con éxito.');
                loadConfig(filename);
            }
        });
    });

    $('#remove-member-btn').click(function() {
        const filename = $('#config-files').val();
        const member_url = $('#member-url').val();
        $.ajax({
            url: `/remove_member/${filename}`,
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ member_url: member_url }),
            success: function(response) {
                alert('Miembro eliminado con éxito.');
                loadConfig(filename);
            }
        });
    });

    // Cargar el archivo de configuración seleccionado al inicio
    loadConfig($('#config-files').val());
});

