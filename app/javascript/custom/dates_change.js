// $(document).on('change', '#inputSearchDate','turbolinks:load', function(){ //リロードしなくてもjsが動くようにする
//   var inputSearchDate = $("#inputSearchDate").val();
// $.ajax({ //ajax通信で以下のことを行います
//     url: '/records/search_dates', //urlを指定
//     type: 'GET', //メソッドを指定
//     data: ('date=' + inputSearchDate), //コントローラーに渡すデータの指定
//     processData: false, //おまじない
//     contentType: false, //おまじない
//     dataType: 'json' //データ形式を指定
//   })
//   .done(function(data){ //データを受け取ることに成功した場合の処理
//     console.log(data)
//     for (var i = 0; i < data.length; i++) {
//       $('tr.record-row').append('.th-date');
//       $(".th-date").val(data[i].m_sbp);
//       console.log(data[i].m_sbp)
//     }
//   })
//     // $(".comment").eq(i).〜
// // }
// //     $(".th-date").val(data[i].m_sbp);
// //     $(".td-m_sbp").val(data[i].m_sbp);
// //     $(".td-m_sbp").val(data[i].m_dbp);
// //     $(".td-m_sbp").val(data[i].m_pulse);
// //     $(".td-m_sbp").val(data[i].n_sbp);
// //     $(".td-m_sbp").val(data[i].n_dbp);
// //     $(".td-m_sbp").val(data[i].n_pulse);
// //     $(".td-m_sbp").val(data[i].memo);
// //   })
//   // .fail(function(data){ //データを受け取ることに失敗した場合の処理
//   //   $("#inputM_SBP").val("");
//   //   $("#inputM_DBP").val("");
//   //   $("#inputM_PLS").val("");
//   //   $("#inputN_SBP").val("");
//   //   $("#inputN_DBP").val("");
//   //   $("#inputN_PLS").val("");
//   //   $("#inputMemo").val("");
//   // })
// });
