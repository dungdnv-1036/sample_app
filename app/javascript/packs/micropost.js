const SIZE_FILE = 5
const MB_TO_BYTE = 1024

$(document).ready(function(){
  $('#micropost_image').bind('change', function() {
    var size_in_megabytes = this.files[0].size / MB_TO_BYTE / MB_TO_BYTE;
    if (size_in_megabytes > SIZE_FILE) {
      alert(I18n.t('.microposts.image_size_notify_js'));
      $(this).val(null);
    }
  });
});
