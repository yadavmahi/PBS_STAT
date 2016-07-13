$( document ).ready(function() { 

var queues = [];
var queuescount=[];
var queuescores=[];
var queuescomment="";
var states = [];
var statescount=[];
var statescores=[];
var statescomment="";
var coresused=0;
var jobsused=0;

$.getJSON( "data.json", function( jdt ) {
console.log(jdt);
//alert("....."+jd);
  $.each( jdt.queue, function( key, val ) {
//alert(val);
    queues.push(val);
    queuescount.push(0);
    queuescores.push(0);
  });
//alert(jdt.qcomment);
  queuescomment=jdt.qcomment;
  $.each( jdt.state, function( key, val ) {
//alert(val);
    states.push(val);
    statescount.push(0);
    statescores.push(0);
  });
  statescomment=jdt.scomment;
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
statescores[i]=parseInt(statescores[i])+parseInt(num);
 }
}

for ( var i =0 ;i < queues.length ;i++){
if (queues[i] == data1) {
queuescount[i]=queuescount[i]+1;
queuescores[i]=parseInt(queuescores[i])+parseInt(num);
 }
}

if(num){
//coresused=coresused+parseInt(data2);
coresused=parseInt(coresused)+parseInt(num);
jobsused=parseInt(jobsused)+1;
}

});

out1='<table class="restable"><thead><tr><th>State</th><th>Job Count</th><th>Cores Count</th></tr></thead>';
//alert(states.length);
for ( var i =0 ;i < states.length ;i++){
out1=out1+'<tr><td class=\"bt\">'+states[i]+'</td><td>'+statescount[i]+'</td><td>'+statescores[i]+'</td></tr>'
}
out1=out1+'<tr><td>Total</td><td>'+jobsused+'</td><td>'+coresused+'</td></tr>'
out1=out1+'<tr><td colspan=3><span class="note">'+statescomment+' </span></td></table>';

out2='<table class="restable"><thead><tr><th>Queue</th><th>Job Count</th><th>Cores Count</th></tr></thead>';
//alert(queues.length);
for ( var i =0 ;i < queues.length ;i++){
out2=out2+'<tr><td class=\"bt1\">'+queues[i]+'</td><td>'+queuescount[i]+'</td><td>'+queuescores[i]+'</td></tr>'
}
out2=out2+'<tr><td>Total</td><td>'+jobsused+'</td><td>'+coresused+'</td></tr>'
out2=out2+'<tr><td colspan=3><span class="note">'+queuescomment+' </span></td></table>';

$('div.left div.res').html(out1+out2);

var i=1;
out5='<span> Search :  </span><select>';
$('#main thead tr th').each(function(){
//alert($(this).text());
out5=out5+'<option value="'+i+'">'+$(this).text()+'</option>';
i=i+1;
});
out5=out5+'</select><input class="sinp" type="text"></input>';
$('div.left div.search').html(out5);


});

function show_table(){
$('#main tr').each(function(){ $(this).show(); });
}

function table_hide(showval){
//alert(showval);
show_table();
$('#main tr').each(function(){
chk=$.trim($(this).children("td:nth-child(4)").text());
if(chk === showval){ $(this).show(); }else{ $(this).hide(); }
});
$('#main thead tr').show();
}
function table_hide1(showval){
//alert(showval);
show_table();
$('#main tr').each(function(){
chk=$.trim($(this).children("td:nth-child(5)").text());
if(chk === showval){ $(this).show(); }else{ $(this).hide(); }
});
$('#main thead tr').show();
}

$('div.left div.res').on('click','.bt',function(){
var dt=$.trim($(this).text());
table_hide(dt);
});
$('div.left div.res').on('click','.bt1',function(){
var dt=$.trim($(this).text());
table_hide1(dt);
});


$('div.search').on('change','input.sinp',function(){
var ssel=$('div.search select option:selected').val();
var stxt=$(this).val();
var jobc=0;
var corec=0;
// alert(stxt+"...."+ssel);
show_table();

if(stxt){
var stxt1=new RegExp(stxt,"i");
$('#main tr').each(function(){
chk=$.trim($(this).children("td:nth-child("+ssel+")").text());
str=chk.match(stxt1);
data2=$.trim($(this).children("td:nth-child(6)").text());
num=parseInt(data2)?data2:0;
//alert(chk+"----"+stxt1+"...."+str);
if(str){ $(this).show(); jobc=jobc+1; corec=corec+parseInt(num); }else{ $(this).hide(); }
});
$('#main thead tr').show();
}else{
jobc=parseInt(jobsused);
corec=parseInt(coresused);
}
$('div.right div.res span').html("Job's Count : <b>"+jobc+"</b> ___ Core's Count : <b>"+corec+"</b>");

});

$('div.search').on('change','select',function(){
// alert('reset');
show_table();
});



$("div.dmain1").show();
$("div.dmain2").hide();
$('.system').click(function(){ $("div.dmain1").show(); $("div.dmain2").hide(); });
$('.details').click(function(){ $("div.dmain1").hide(); $("div.dmain2").show(); });

});

