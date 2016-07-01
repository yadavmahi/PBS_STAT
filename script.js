$( document ).ready(function() { 

var queues = [];
var queuescount=[];
var queuescores=[];
var states = [];
var statescount=[];
var coresused=0;

$.getJSON( "data.json", function( jdt ) {
//alert("....."+jd);

  $.each( jdt.queue, function( key, val ) {
//alert(val);
    queues.push(val);
    queuescount.push(0);
    queuescores.push(0);
  });
  $.each( jdt.state, function( key, val ) {
//alert(val);
    states.push(val);
    statescount.push(0);
  });
}).done(function() {
    console.log( "second success" );

$('#main tr').each(function() {
data=$.trim($(this).children("td:nth-child(4)").text());
data1=$.trim($(this).children("td:nth-child(5)").text());
data2=$.trim($(this).children("td:nth-child(6)").text());
num=parseInt(data2)?data2:0;

//alert(data);
for ( var i =0 ;i < states.length ;i++){
if (states[i] == data) { 
statescount[i]=statescount[i]+1;
 }
}

for ( var i =0 ;i < queues.length ;i++){
if (queues[i] == data1) {
queuescount[i]=queuescount[i]+1;
queuescores[i]=parseInt(queuescores[i])+parseInt(num);
 }
}

//coresused=coresused+parseInt(data2);
coresused=parseInt(coresused)+parseInt(num);

});

out1='<table class="restable"><thead><tr><th>State</th><th>Job Count</th></tr></thead>';
//alert(states.length);
for ( var i =0 ;i < states.length ;i++){
out1=out1+'<tr><td>'+states[i]+'</td><td>'+statescount[i]+'</td></tr>'
}
out1=out1+'<tr><td colspan=2><span class="note">* : R - Running,<br> Q - Waiting state ,<br> E - Error state </span></td></table>';

out2='<table class="restable"><thead><tr><th>Queue</th><th>Job Count</th></tr></thead>';
//alert(queues.length);
for ( var i =0 ;i < queues.length ;i++){
out2=out2+'<tr><td>'+queues[i]+'</td><td>'+queuescount[i]+'</td></tr>'
}
out2=out2+'</table>';

out3='<table class="restable"><thead><tr><th>Alloted Cores</th><th>'+coresused+'</th></tr></thead>';
for ( var i =0 ;i < queues.length ;i++){
out3=out3+'<tr><td>'+queues[i]+'</td><td>'+queuescores[i]+'</td></tr>'
}
out3=out3+'</table>';

$('div.left div.res').html(out1+out2+out3);


});


// Buttons script
$("#buttons span").click(function(){
function table_hide(showval){
//alert(showval);
$('main tr').show();
$('#main tr').each(function(){
chk=$.trim($(this).children("td:nth-child(4)").text());
if(chk === showval){ $(this).show(); }else{ $(this).hide(); }
});
$('#main thead tr').show();
}

var id = $(this).attr("class");
//alert("hai"+id);
if(id == "run"){
table_hide('R');
}
if(id == "que"){
table_hide('Q');
}
if(id == "err"){
table_hide('E');
}
});

});

