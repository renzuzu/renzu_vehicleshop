var CurrentVehicle = {};
var CurrentVehicle_ = {};
var VehicleArr = []
var garage_id = undefined
var currentcar
var chopper = false
var inGarageVehicle = {}
var categories = {}
var payment = 'cash'

function changecategory(c,v) {
    //console.log(c,v)
    $.post("https://renzu_vehicleshop/choosecategory", JSON.stringify({ id: v, category: c}));
}

function icon(c) {
    //console.log(c)
    if (c == 'suvs') {
        return 'fas fa-shuttle-van'
    }
    if (c == 'vans') {
        return 'fas fa-shuttle-van'
    }
    if (c == 'compacts') {
        return 'fas fa-car-side'
    }
    if (c == 'motorcycles') {
        return 'fas fa-motorcycle'
    }
    if (c == 'offroad') {
        return 'fas fa-truck-monster'
    }
    if (c == 'compacts') {
        return 'fas fa-car-side'
    }
    if (c == 'muscle') {
        return 'fas fa-taxi'
    }
    return 'fas fa-car'
}
window.addEventListener('message', function(event) {
    var data = event.data;
    if (event.data.type == "cleanup") {
        cleanup()
    }
    if (event.data.type == "categories") {
        categories = event.data.cats
        $('#category').empty();
        //console.log(categories)
        for(var [k,v] of Object.entries(categories)){
            //console.log(k,v)
            $('#category').append(`</li>
            <li class="darkerlishadow">
            <a onclick="changecategory('`+k+`','`+v+`');">
            <i class="`+icon(''+k+'')+`"></i>
            <span class="nav-text">`+k+`</span>
            </a>
            </li>`)
        }
    }
    if (event.data.garage_id) {
        garage_id = event.data.garage_id
    }
    if (event.data.type == "ownerinfo") {
    var offset = +8;
    var utcSeconds = event.data.chopstats;
    const unixTimestamp = 1575909015

    const milliseconds = utcSeconds * 1000 // 1575909015000

    const dateObject = new Date(milliseconds)

    const humanDateFormat = dateObject.toLocaleString()
        document.getElementById("dateissue").innerHTML = humanDateFormat;
        for(var [key,value] of Object.entries(data.info)){
            for(var [k,v] of Object.entries(value)){
                if (k == 'name') {
                    document.getElementById("ownerinfo").innerHTML = v;
                }
                if (k == 'phone_number') {
                    document.getElementById("contact").innerHTML = v;
                }
                if (k == 'job') {
                    document.getElementById("job").innerHTML = v;
                }
            }     
        }
    }
    if (event.data.type == "stats") {
        if (event.data.show) {
            document.getElementById("perf").style.display = 'block';
            if (!event.data.public) {
                document.getElementById("seemod").style.display = 'block';
            }
            for(var [k,v] of Object.entries(event.data.perf)){
                if (k =='name' || k =='plate' || k =='turbo' || k =='seat' || k =='gear' || k =='drivetrain' || k =='weight') {
                    document.getElementById(k).innerHTML = v;
                } else {
                    document.getElementById(k).style.width = ''+v+'%';
                }
            }
        } else {
            document.getElementById("perf").style.display = 'none';
            document.getElementById("seemod").style.display = 'none';
        }
    }
    if (event.data.chopper) {
        chopper = true
    }
    if (event.data.type == "display") {
        $('.vehiclegarage').empty();
        $('.app_inner').empty();
        chopper = false
        if (event.data.chopper) {
            chopper = true
        }
        VehicleArr = undefined
        currentcar = undefined;
        VehicleArr = [];
        CurrentVehicle = [];
        $("#garage").fadeIn();
        document.getElementById("garage").style.display = 'block';
        for(var [key,value] of Object.entries(data.data)){   
            for(var [k,v] of Object.entries(value)){
                VehicleArr.push(v);          
            }             
        }
        renzu_vehicleshop.Open(VehicleArr);
        ShowVehicle(0);
        document.getElementById("shopicon").src = event.data.shop.icon || '';
        document.getElementById("shopname").innerHTML = event.data.shop.shop || 'VehicleShop';
        if (event.data.quickpick) {
            document.getElementById("customextra").style.display = 'none';
        }
    }

    if (event.data.type == "hide") {
        document.getElementById("garage").style.display = 'none';
        $("#garage").fadeOut();
    }

    if (event.data.type == "notify") {       
        var data = event.data;

        $("#messagePopup").css("background-color","rgb(252, 0, 0)");      

        $("#messagePopup").fadeIn(500);      
        
        $('#messagePopup').append(`

        <span>`+ data.message +`</span>    
        
        `)
        
        setTimeout(function(){ $("#messagePopup").fadeOut(500);         document.getElementById("messagePopup").innerHTML = ''; }, 3000);

    }

});

$(document).ready(function() {
    $('.upper-bottom-container').on('afterChange', function(event, slick, currentSlide) {
        
        $('.button-container').appendTo(currentSlide);
    });

    var app = '<main id="customextra" style="padding:10px;display:block;">\
    <header style="text-align:center;padding:5px;"><button onclick="choosecolor(`primary`)" class="confirm_out" style="background:#414244;color:#fff !important;border-radius: 10px;width: 30%;background: #414244;color: #fff !important;border-radius: 10px;width: 30%;/* padding-right: 20px; */height: 20px;font-size: 10px;margin-top: 1px !important;height: 100%;margin-right: 20px;">primary</button><button onclick="choosecolor(`secondary`)" class="confirm_out" style="background:#414244;color:#fff !important;border-radius: 10px;width: 30%;/* padding-right: 20px; */height: 20px;font-size: 10px;margin-top: 1px;height: 100%;">Secondary</button></header>\
    <div class="colors" style="height:170px;overflow-x:hidden;"></div>\
    <header style="text-align: center;\
    padding: 6px;\
    font-size: 15px;\
    color: #fff;\
    padding-bottom: 0;\
    height: 20px;\
}"> Liveries </header>\
    <header style="text-align:center;padding: 6px;"><button onclick="livery(false)" class="confirm_out" style="background:#414244;color:#fff !important;border-radius: 10px;width: 30%;background: #414244;color: #fff !important;border-radius: 10px;width: 30%;/* padding-right: 20px; */height: 20px;font-size: 10px;margin-top: -10px !important;height: 100%;margin-right: 20px;"><i style="display:contents;" class="fas fa-arrow-left"></i></button><button onclick="livery(true)" class="confirm_out" style="background:#414244;color:#fff !important;border-radius: 10px;width: 30%;/* padding-right: 20px; */height: 20px;font-size: 10px;margin-top: -10px;height: 100%;"> <i style="display:contents;" class="fas fa-arrow-right"></i></button></header>\
  </main>\
  <div class="container">\
    <div class="right">\
        <nav class="main-menu">\
        <div class="scrollbar" id="style-1">\
        <ul id="category">\
        </ul>\
        </nav>\
      <div class="app">\
      <div style="position: absolute;top: -12%;right: 0%;width: 100%;height: 80px;background: linear-gradient(        90deg        , rgb(0 0 0 / 95%) 0%, rgb(4 4 4 / 77%) 100%);border-radius: 10px;z-index: -1;padding: 25px;text-align: center;font-size: 20px;color: #fff;border-style: solid;border-color: aliceblue;border-bottom-style: unset;border-right-style: unset;border-left-style: none;"><img style="display: block; height: 60px; position: absolute; top: 2%; left: 9%;" id="shopicon" src="https://i.imgur.com/05SLYUP.png"/> <span id="shopname">Vehicle Lists </span></div>\
        <div class="app_inner" id="vehlist">\
        </div>\
      </div>\
    </div>\
    <div id="closemenu" class="modal" style="background-color:#050505c5 !important; color:#fff;">\
  </div>\
    <div class="middle-left-container" style="/* display:none; */position: absolute;top: 0%;left: 1%;background: unset;width: 40%;">\
    <div class="column" style="display:block;" id="nameBrand">\
    </div>\
    <div class="column" id="vehicleclass">\
    </div>\
    </div>\
  <div class="middle-left2-container">\
      <div class="column" id="contentVehicle">\
      </div>\
  </div>\
  <div id="messagePopup">\
  </div>\
  <div class="bottom-container"></div>\
  <div class="top-triangle"></div>\
</div>'

$('#garage').append(app);

const colorsEl = document.querySelector('.colors');

const resetSelection = () => Array.from(document.querySelectorAll('.colors div')).map((listItem) => listItem.classList.remove('selected'));

const colors = Array.from({ length: 255 }, () => {
  const color = chance.color({format: 'rgb'});
  const div = document.createElement('div');
  const span = document.createElement('span');

  span.className = 'color';
  span.style.background = color;
  span.onclick = () => {
    resetSelection();
    span.parentNode.classList.toggle('selected');
    //document.body.style.background = color;
    $.post("https://renzu_vehicleshop/choosecolor", JSON.stringify({ r: getRGB(color).r, g:getRGB(color).g, b:getRGB(color).b }))
    console.log(getRGB(color).r)
  };
  
  div.append(span);
  
  colorsEl.append(div); 
});
});

function choosecolor(type) {
    console.log(type)
    $.post("https://renzu_vehicleshop/selectcolortype", JSON.stringify({ type:type }))
}

function livery(next) {
    console.log(next)
    $.post("https://renzu_vehicleshop/setlivery", JSON.stringify({ next:next }))
}

function getRGB(str){
    var match = str.match(/rgba?\((\d{1,3}), ?(\d{1,3}), ?(\d{1,3})\)?(?:, ?(\d(?:\.\d?))\))?/);
    return match ? {
      r: match[1],
      g: match[2],
      b: match[3]
    } : {};
  }

function ShowVehicle(currentTarget) {
    var data = inGarageVehicle[currentTarget]
    if (currentcar !== currentTarget) {
        currentcar = currentTarget
        var div = $(this).parent().find('.active');        
        $(div).removeClass('active');
        var itemDisabled = false;
        if(!itemDisabled && garage_id != 'impound') {
            $(currentTarget).addClass('active');
            $('.modal').css("display","none");

            document.getElementById("nameBrand").innerHTML = '';
            document.getElementById("vehicleclass").innerHTML = '';
            document.getElementById("contentVehicle").innerHTML = '';
                        
            document.getElementById("vehicleclass").innerHTML = ' ';

            $('#nameBrand').append(`
                <span id="vehicle_class" style="font-size:2em;">`+data.brand+`,</span> 
                <span id="vehicle_name">`+data.name+`</span> 
            `);

            $(".menu-modifications").css("display","block");

            CurrentVehicle = {brand: data.brand, model: data.model, modelcar: data.model2, sale: 1, name: data.name, props: data.props, shop: data.shop ,payment: payment}
            $('#contentVehicle').append(`
                <div class="row spacebetween">
                    <span class="title">HANDLING</span>
                    <span>`+data.handling.toFixed(1)+`</span>
                </div>

                <div class="row">
                <div class="w3-border" style="width: 100%;
                margin-left: 10px;"> <div class="w3-grey" style="height:5px;width:`+data.handling.toFixed(1)/10*100+`%"></div> </div>
                </div>

                <div class="row spacebetween">
                    <span class="title">TOP SPEED</span>
                    <span>`+data.topspeed.toFixed(0)+` KM/H</span>
                </div>

                <div class="row">
                <div class="w3-border" style="width: 100%;
                margin-left: 10px;"> <div class="w3-grey" style="height:5px;width:`+data.topspeed.toFixed(1)/520*100+`%"></div> </div>
                </div>

                <div class="row spacebetween">
                    <span class="title">HORSE POWER</span>
                    <span>`+data.power.toFixed(0)+` HP</span>
                </div>

                <div class="row">
                <div class="w3-border" style="width: 100%;
                margin-left: 10px;"> <div class="w3-grey" style="height:5px;width:`+data.topspeed.toFixed(1)/500*100+`%"></div> </div>
                </div>

                <div class="row spacebetween">
                    <span class="title">TORQUE</span>
                    <span>`+data.torque.toFixed(0)+` TQ</span>
                </div>

                <div class="row">
                <div class="w3-border" style="width: 100%;
                margin-left: 10px;"> <div class="w3-grey" style="height:5px;width:`+data.torque.toFixed(1)/500*100+`%"></div> </div>
                </div>

                <div class="row spacebetween">
                    <span class="title">BRAKE</span>
                    <span>`+data.brake.toFixed(1)+`</span>
                </div>

                <div class="row">
                <div class="w3-border" style="width: 100%;
                margin-left: 10px;"> <div class="w3-grey" style="height:5px;width:`+data.brake.toFixed(1)/2*100+`%"></div> </div>
                </div>
            `);
            $.post("https://renzu_vehicleshop/SpawnVehicle", JSON.stringify({ modelcar: data.model2 }));
        }
    }

}
function garage() {
    $.post("https://renzu_vehicleshop/gotogarage", JSON.stringify({id: garage_id }));
}

function BuyVehicle(n,c,p) {
    payment = 'cash'
    //console.log(n,c,p)
    document.getElementById("closemenu").innerHTML = '';

    $('.modal').css("display","flex");

    $('#closemenu').append(`
        <div class="background-circle"></div>
        <div class="modal-content">
            <p class="title">Confirm Purchase:</p>
            <br>
            <p class="vehicle">Vehicle: `+n+`</p>
            <p style="float:left;" class="vehicle">Class: `+c+`</p>
            <p style="float:right;" class="vehicle">$ `+p+`</p>
        </div>

        <div class="modal-footer">
            <div class="modal-buttons">     
                <div>
                    <span>Buy</span>
                    <button id="money" class="modal-money button" onclick="BuyVehicleCallback('confirm')" >✔️</button>
                </div>
                <div>
                    <span>Cancel</span>
                    <button href="#!" id="card" class="modal-money button" onclick="BuyVehicleCallback('cancel')">X</button>
                </div>
            </div>
            <div class="wrapper">
            <input type="radio" name="select" id="option-1" checked>
            <input type="radio" name="select" id="option-2">
            <label for="option-1" class="option option-1">
            <div class="dot"></div>
            <span>Cash</span>
            </label>
            <label for="option-2" class="option option-2">
            <div class="dot"></div>
            <span>Bank</span>
            </label>
            </div>
        </div>
    `);
    $('input[type=radio][id=option-1]').change(function() {
        if (this.value == 'on') {
            CurrentVehicle.payment = 'cash'
            console.log(CurrentVehicle.payment)
        }
    });
    $('input[type=radio][id=option-2]').change(function() {
        if (this.value == 'on') {
            CurrentVehicle.payment = 'bank'
            console.log(CurrentVehicle.payment)
        }
    });
}

function TestDrive(n,c,p,m) {
    //console.log(n,c,p,m)
    document.getElementById("closemenu").innerHTML = '';

    $('.modal').css("display","flex");

    $('#closemenu').append(`
        <div class="background-circle"></div>
        <div class="modal-content">
            <p class="title">Confirm Test Drive:</p>
            <br>
            <p class="vehicle">Vehicle: `+n+`</p>
            <p style="float:left;" class="vehicle">Class: `+c+`</p>
            <p style="float:right;" class="vehicle">Time: 5 minutes</p>
        </div>

        <div class="modal-footer">
            <div class="modal-buttons">     
                <div>
                    <span>Buy</span>
                    <button id="money" class="modal-money button" onclick="TestDriveCallback('confirm')" >✔️</button>
                </div>
                <div>
                    <span>Cancel</span>
                    <button href="#!" id="card" class="modal-money button" onclick="TestDriveCallback('cancel')">X</button>
                </div>
            </div>
        </div>
    `);
}

function BuyVehicleCallback(option) {
    //console.log("BUY")
    $('.modal').css("display","none");
        VehicleArr = []
        switch(option) {
            case 'cancel':
                break;
            case 'confirm':
                $.post('https://renzu_vehicleshop/BuyVehicleCallback', JSON.stringify(CurrentVehicle));
                CurrentVehicle_ = CurrentVehicle
                CurrentVehicle = {}
                break;
    }
}

function TestDriveCallback(option) {
    //console.log("TEST")
    $('.modal').css("display","none");
        VehicleArr = []
        switch(option) {
            case 'cancel':
                break;
            case 'confirm':
                $.post('https://renzu_vehicleshop/TestDriveCallback', JSON.stringify(CurrentVehicle));
                CurrentVehicle_ = CurrentVehicle
                CurrentVehicle = {}
                break;
    }
}

function returnvehicle(option) {
    $('.modal').css("display","none");
    VehicleArr = []
    switch(option){
        case 'cancel':
            break;
        case 'confirm':
            $.post('https://renzu_vehicleshop/ReturnVehicle', JSON.stringify(CurrentVehicle_));
            CurrentVehicle_ = {}
            break;
    }
}

function cleanup() {
    document.getElementById("vehlist").innerHTML = '';
}

var scrollAmount = 0

$(document).on('keydown', function(event) {
    switch(event.keyCode) {
        case 27: // ESC
            VehicleArr = []
            CurrentVehicle = {}
            $.post('https://renzu_vehicleshop/Close');
            break;
        case 9: // TAB
            break;
        case 17: // TAB
            break;
    }
});

    $('.vehiclegarage').empty();
    $('.app_inner').empty();
    $('#category').empty();
(() => {
    renzu_vehicleshop = {};
    inGarageVehicle = {}
    renzu_vehicleshop.Open = function(data) {
        if (document.getElementById("vehlist")) {
            document.getElementById("vehlist").innerHTML = '';
        }
        for(i = 0; i < (data.length); i++) {
            var modelUper = data[i].model;
            var imagecar = data[i].image;
            ////console.log(modelUper)
            inGarageVehicle[i] = data[i]
            $(".app_inner").append('<label style="cursor:pointer;"><input false="" id="tab-'+ i +'" onclick="ShowVehicle('+i+')" name="buttons" type="radio"> <label for="tab-'+ i +'"> <div class="app_inner__tab"> <span style="position:absolute;top:4px;left:8px;font-size:8px;color:#b0b1b1;font-weight: 500;">Class: '+ data[i].category +'</span> <span style="position:absolute;top:4px;right:5px;font-weight: 700;font-size:12px;color:#5ab34f;">Price: '+ data[i].price +'</span><h2 style="font-size:11px !important;"> <i class="icon" style="right:100px;"><img style="height:20px;" src="https://cdn.discordapp.com/attachments/709992715303125023/813351303887192084/wheel.png"></i> '+ data[i].name +' </h2> <div class="tab_left"> <i class="big icon"><img class="imageborder" style="width: 120%;height:80px;height: 80px;border-radius: 10px;border-width: medium;border-color: #fdfdfd;border-style: groove;" onerror="this.src=`https://cdn.discordapp.com/attachments/709992715303125023/813351303887192084/wheel.png`;" src="' + imagecar + '"></i>   </div> <div class="tab_right"> <button class="confirm_out" style="background:#414244" onclick="BuyVehicle(`'+ data[i].name +'`,`'+ data[i].category +'`,`'+ data[i].price +'`)"> Buy </button> <div class="row" id="confirm" style="width: 100%;"> <button class="confirm_out" style="background:#414244;" onclick="TestDrive(`'+ data[i].name +'`,`'+ data[i].category +'`,`'+ data[i].price +'`,`'+ data[i].model +'`)"> Test Drive </button> </div> </div> </div> </label></input></label>');    
        }     
    }
    renzu_vehicleshop.Open(VehicleArr)
})();