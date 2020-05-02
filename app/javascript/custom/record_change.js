$(document).on('change', '#inputDate','turbolinks:load', function(){ //リロードしなくてもjsが動くようにする
  var inputDate = $("#inputDate").val();
$.ajax({ //ajax通信で以下のことを行います
    url: '/records/search', //urlを指定
    type: 'GET', //メソッドを指定
    data: ('date=' + inputDate), //コントローラーに渡すデータの指定
    processData: false, //おまじない
    contentType: false, //おまじない
    dataType: 'json' //データ形式を指定
  })
  .done(function(data){ //データを受け取ることに成功した場合の処理
    $("#inputM_SBP").val(data.m_sbp);
    $("#inputM_DBP").val(data.m_dbp);
    $("#inputM_PLS").val(data.m_pulse);
    $("#inputN_SBP").val(data.n_sbp);
    $("#inputN_DBP").val(data.n_dbp);
    $("#inputN_PLS").val(data.n_pulse);
    $("#inputMemo").val(data.memo);
    $("#destroy_form").attr("action", `/records/${data.id}`);
    $("#destroy_form").attr("href", `/records/${data.id}`);
    if(data.id == null){
      $("#destroy_form").addClass('disabled');
    } else {
      $("#destroy_form").removeClass('disabled');
    }
    if(inputDate == "") {
      $("#record-btn").addClass('inactive');
      $("#record-btn").attr('disabled', true);
      $("#record-btn").before('<p class="record-btn-alert">日付を入力してください</p>');
    } else {
      $("#record-btn").removeClass('inactive');
      $("#record-btn").attr('disabled', false);
      $(".record-btn-alert").remove();
    }
  })
  .fail(function(data){ //データを受け取ることに失敗した場合の処理
    $("#inputM_SBP").val("");
    $("#inputM_DBP").val("");
    $("#inputM_PLS").val("");
    $("#inputN_SBP").val("");
    $("#inputN_DBP").val("");
    $("#inputN_PLS").val("");
    $("#inputMemo").val("");
  })
});
