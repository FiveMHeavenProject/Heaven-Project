let max = {};
let min = {};

window.addEventListener("message", function (event) {
  let data = event.data;


  if (data.action == 'openMenu') {
    $(".skinmenu-categories").html("");
    $(".skinmenu-items").html("");

    let elements = data.elements;

    const categories = [...new Set(elements.map(element => element.category.name))].map(name => {
      return {
        name,
        button: elements.find(element => element.category.name === name).category.button
      }
    });

    categories.forEach(category => {
      $(".skinmenu-categories").append(`<button id="skinmenu-button-${category.name}">${category.button}</button>`);
      $(".skinmenu-items").append(`<div class="skinmenu-items-tabs" id="tab-${category.name}"></div>`);
      $(`#skinmenu-button-${category.name}`).on("click", function () {
        $(".skinmenu-categories button").removeClass("active");
        $(`#skinmenu-button-${category.name}`).addClass("active");
        $(".skinmenu-items-tabs").hide();
        $(`#tab-${category.name}`).show();
      });
      const elementsInCategory = elements.filter(element => element.category.name === category.name);

      elementsInCategory.forEach(element => {
        let label = element.label;
        let name = element.name;
        let value = element.value;
        let maxb = element.max;
        let minb = element.min;
        max[name] = maxb;
        min[name] = minb;
        $(`#tab-${category.name}`).append(`
            <div class="item ${name}">
              <div class="title">
                <p>${label}</p> 
                <div>
                  <button class="arrow" onclick="changeInput('${name}', '${label}', 'decrease')"><i
                  class="fa-solid fa-chevron-left"></i></button>
                  <input min="${min[name]}" max="${max[name]}" type="number" class="manualinput" onclick="this.select()" onchange="changeInput('${name}', '${label}', 'input')" value="${value}" />
                  <button class="arrow" onclick="changeInput('${name}', '${label}', 'increase')"><i
                  class="fa-solid fa-chevron-right"></i></button>
                </div>
              </div>
              <input min="${min[name]}" max="${max[name]}" step="1" oninput="changeInput('${name}', '${label}', 'range')" type="range" class="range value" value="${value}">
            </div>
          `);
      });
    });
    $(".skinmenu-categories").append(`<button class="submit" onclick="submit()"><i class="fa-solid fa-floppy-disk"></i>
      <p>Zapisz</p>
  </button>`)

    $(".skinmenu-categories button").first().addClass("active");
    $(".skinmenu-items-tabs").hide();
    $(".skinmenu-items-tabs").first().show();

    $("body").show();
  } else if (data.action == 'updateVals') {
    let label = data.label;
    let namee = data.name;
    let maxe = data.max;
    let mine = data.min;
    max[namee] = maxe;
    min[namee] = mine;

    console.log(label)

    $(".item." + namee + " > .range").attr("max", maxe);
    $(".item." + namee + " > .range").attr("min", mine);

    if(data.value > data.max) data.value = data.max

    if (data.value !== -1) {
      $(".item." + namee + " > .range").val(data.value);
      $(".item." + namee + " > .title > div > input").val(data.value);
    }
  }

});

changeInput = function (name, label, inputtype) {
  let value;

  if (inputtype === 'range')
    value = Number($(".item." + name + " > .range").val());
  else {
    let thisblock = $(".item." + name + " > .title > div > .manualinput");
    let min = thisblock.attr('min');
    let max = thisblock.attr('max');
    if (inputtype === 'input') {
      value = Number(thisblock.val());
  
      if (value < min) {
        thisblock.val(Number(min));
        value = Number(min);
      } else if (value > max) {
        thisblock.val(Number(max));
        value = Number(max);
      }
  
      $(".item." + name + " > .range").val(value);
    } else if (inputtype === 'decrease') {
      value = Number(thisblock.val()) - 1;
  
      if (value < min) {
        thisblock.val(Number(min));
        value = Number(min);
      }

    } else if (inputtype === 'increase') {
      value = Number(thisblock.val()) + 1;

      if (value > max) {
        thisblock.val(Number(max));
        value = Number(max);
      }
    } 
  
    $(".item." + name + " > .range").val(value); 
  }
  $('.item.' + name + " > .title").html(`<p>${label}</p> 
                                          <div>
                                            <button class="arrow" onclick="changeInput('${name}', '${label}', 'decrease')"><i
                  class="fa-solid fa-chevron-left"></i></button>
                                              <input min="${min[name]}" max="${max[name]}" type="number" class="manualinput" onclick="this.select()" onchange="changeInput('${name}', '${label}', 'input')" value="${value}" />
                                            <button class="arrow" onclick="changeInput('${name}', '${label}', 'increase')"><i
                  class="fa-solid fa-chevron-right"></i></button>
                                          </div>
                                          `);
  $.post(`https://${GetParentResourceName()}/change`, JSON.stringify({
    name: name,
    value: value
  }));
};

const submit = () => {
  $("body").hide();
  $.post(`https://${GetParentResourceName()}/submit`, JSON.stringify({}));
}


window.addEventListener("keydown", (event) => {
  if (event.key == "Escape") {
    $("body").hide();
  $.post(`https://${GetParentResourceName()}/cancel`, JSON.stringify({}));
  }
})


$(".cameras.rotation .range").on("input", function () {
  let value = Number($(".cameras.rotation .range").val());
  $.post(`https://${GetParentResourceName()}/rotation`, JSON.stringify({
    value: value
  }));
});

$(".cameras.height .range").on("input", function () {
  let value = Number($(".cameras.height .range").val());
  $.post(`https://${GetParentResourceName()}/height`, JSON.stringify({
    value: value
  }));
});

$(".cameras.zoom .range").on("input", function () {
  let value = Number($(".cameras.zoom .range").val());
  $.post(`https://${GetParentResourceName()}/zoom`, JSON.stringify({
    value: value
  }));
});

document.addEventListener('keydown', function (event) {
  switch(event.which) {
    case 65:
      $.post(`https://${GetParentResourceName()}/left`, JSON.stringify({
        value: true
      }));
      break;
    case 68:
      $.post(`https://${GetParentResourceName()}/right`, JSON.stringify({
        value: true
      }));
      break;

    case 189:
      $.post(`https://${GetParentResourceName()}/zoommin`, JSON.stringify({
        value: true
      }));
      break;
    case 187:
      $.post(`https://${GetParentResourceName()}/zoomplus`, JSON.stringify({
        value: true
      }));
      break; 

    case 87:
      $.post(`https://${GetParentResourceName()}/heightplus`, JSON.stringify({
        value: true
      }));
      break; 
    case 83:
      $.post(`https://${GetParentResourceName()}/heightmin`, JSON.stringify({
        value: true
      }));
      break;
    case 192:
      $.post(`https://${GetParentResourceName()}/handsup`, JSON.stringify({}));
      break;

    default:
      break;
  }
})
document.addEventListener('keyup', function (event) {
  switch(event.which) {
    case 65:
      $.post(`https://${GetParentResourceName()}/left`, JSON.stringify({
        value: false
      }));
      break;
    case 68:
      $.post(`https://${GetParentResourceName()}/right`, JSON.stringify({
        value: false
      }));
      break;

    case 189:
      $.post(`https://${GetParentResourceName()}/zoommin`, JSON.stringify({
        value: false
      }));
      break;
    case 187:
      $.post(`https://${GetParentResourceName()}/zoomplus`, JSON.stringify({
        value: false
      }));
      break; 
    case 87:
      $.post(`https://${GetParentResourceName()}/heightplus`, JSON.stringify({
        value: false
      }));
      break; 
    case 83:
      $.post(`https://${GetParentResourceName()}/heightmin`, JSON.stringify({
        value: false
      }));
      break; 

    default:
      break;
  }
})

$(window).bind('mousewheel', function(event) {
  if ($('.skin-menu').is(':hover')) return
  if (event.originalEvent.wheelDelta >= 0) {
    $.post(`https://${GetParentResourceName()}/heightchange`, JSON.stringify({
      value: -0.1
    }));
  }
  else {
    $.post(`https://${GetParentResourceName()}/heightchange`, JSON.stringify({
      value: 0.1
    }));
  }
});
