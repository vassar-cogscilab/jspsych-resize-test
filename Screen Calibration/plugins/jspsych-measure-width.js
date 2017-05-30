/**
 * jspsych-measure-width
 * Steve Chao
 *
 * plugin to record the width of a stimulus
 *
 **/


jsPsych.plugins["measure-width"] = (function() {

  var plugin = {};

  plugin.info = {
    name: 'measure-width',
    description: '',
    parameters: {
      stimulus: {
        type: [jsPsych.plugins.parameterType.STRING],
        default: undefined,
        no_function: false,
        description: ''
      },
      prompt: {
        type: [jsPsych.plugins.parameterType.STRING],
        default: '',
        no_function: false,
        description: ''
      },
      ruler: {
        type: [jsPsych.plugins.parameterType.BOOL],
        default: false,
        no_function: false,
        description: ''
      },

    }
  }

  plugin.trial = function(display_element, trial) {

    // if any trial variables are functions
    // this evaluates the function and replaces
    // it with the output of the function
    trial = jsPsych.pluginAPI.evaluateFunctionParameters(trial);

    // set default values for the parameters
    //trial.timing_response = trial.timing_response || -1;
    trial.ruler = trial.ruler || false;
    trial.prompt = trial.prompt || "";
    trial.button_label = trial.button_label || "Done";
    trial.input_label = trial.input_label || "inch(es)";
    trial.input_width_label = trial.input_width_label || "measured width:";

    // adds stimulus
    var new_html = '';
    if (trial.is_html) {
      new_html = '<div id = "jspsych-stim">'+trial.stimulus+'</div>';
    }

    // adds prompt
    new_html += trial.prompt;

    // adds space
    new_html += '<p></p>';

    // checks browser
    var leftAlignment;
    (!!window.sidebar) ? (leftAlignment = -2) : (leftAlignment = 6);

    // adds ruler
    if (trial.ruler) {
      new_html += '<div>'
      new_html += '<form id = "rulerForm" style = "position: relative; width: 70%">';
      new_html += '<img src = "img/ruler.jpg" style = "width: 1000px; position: relative; top: 10px"></img>';
      new_html += '<input type = "range" name = "widthRangeSlider" max = "12.00" min = "0" step = ".01" value = "0.00" oninput = "widthRangeValue.value = value" style = "-webkit-appearance: none; -moz-appearance: textfield; width: 983px; background: transparent; position: absolute; top: -16px; left: '+leftAlignment+'px; cursor: pointer; outline: none"></input>';
      new_html += '<p style = "position: relative; left: 265px; top: 26px; outline: none; margin: 0; text-align: left">'+trial.input_width_label+'</p>';
      new_html += '<input type = "number" name = "widthRangeValue" max = "12.00" min = "0" step = ".01" value = "0.00" oninput = "widthRangeSlider.value = value" style = "position: absolute; top: 140px; width: 120px; left: 60%; font-size: 18px"></input>';
      new_html += '<p style = "position: relative; left: 475px; top: -4px; outline: none; margin: 0; text-align: left">'+trial.input_label+'</p>';
      new_html += '<a class ="jspsych-btn" id = "jsPsych-btn" style = "position: relative; top: -36px; left: 240px">'+trial.button_label+'</a>';
      new_html += '</form></div>';
    }

    // variable
    var stimulus_number;
    var stimulus_height;
    var stimulus_width;

    // gets stimulus number
    function getStimulus() {
      var tag = "div";
      var stimuli = document.getElementsByTagName(tag);
      for (var i = 0; i < stimuli.length; i++) {
        if (stimuli[i].id.indexOf("box") !== -1) {
          stimulus_number = stimuli[i].id;
          stimulus_height = document.getElementById(stimulus_number).offsetHeight;
          stimulus_width = document.getElementById(stimulus_number).offsetWidth;
        };

      };
    };

    // draw
    display_element.innerHTML = new_html;

    // function to end trial when it is time
    function end_trial() {

      // clear the display
      display_element.innerHTML = '';

      // gather the data to store for the trial
      var trial_data = {
        'reported_width': reported_width,
        'stimulus': stimulus_number,
        'stimulus_height_px': stimulus_height,
        'stimulus_width_px': stimulus_width,
      };

      // move on to the next trial
      jsPsych.finishTrial(trial_data);
    };


    // variabe
    var reported_width;


    // adds event listener to the button
    document.getElementById("jsPsych-btn").addEventListener('click', function() {
      reported_width = parseFloat(document.getElementsByName("widthRangeValue")[0].value);
      if (reported_width !== (null || 0)) {
        getStimulus();
        end_trial();
      } else {
        window.alert("The height or width of the image can't be 0 or blank");
      }
    });

  };

  return plugin;
})();
