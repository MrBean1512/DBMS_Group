// Javascript file to hold behavior related to the create Task form

// Node for createTask form identified by id "createTask"
var createForm = document.getElementById("createTask");

// Node for the entire form object idenified 
var createFormObj = document.getElementById("createForm");

if (createFormObj != null && createForm != null) {
    // Node for show button that toggles the display of the form or not
    var showButtonNode = document.getElementById("displayCreate");

    // True when the form should be visible the client, initially false (not showing)
    var showCreate = false;

    // Define the behavior for the show button    
    showButtonNode.addEventListener("click", function() {
        if (!showCreate) {
            // Hide the form object by moving it outside of visible range
            createFormObj.style.top = -createFormObj.style.height;
        }
        else {
            // Show by moving it down into visible range
            createFormObj.style.top = createFormObj.style.height;
        }
        // Set show variable to other state
        showCreate = !showCreate;
    });

    // Add event listener for the show button of the form to adjust the height when clicked
    // Add an event listener for when submit is activated and perform the POST request when it happens 
    createForm.addEventListener("submit", async function(event) {
        // Preventing default reload request/expectation
        event.preventDefault();
        // Get the form object in the document
        
        // Iterate through the form data, appending onto a string
        // i is index value, s_content to contain what is within the input fields and will be body of POST request
        var i, s_content;
        // Make sure to initialize s_content to empty string before adding anything
        s_content = "";
        var dateSubmit, date, time;
        for (i = 0; i < createForm.length-1; i++) {
            // Add this input field's content, using id to identify the variable being set
            if (createForm[i].id == "due_date") {
                date = createForm[i].value;
            }
            else if (createForm[i].id == "due_time" ) {
                time = createForm[i].value;
            }
            else  {
                s_content += createForm[i].id + "=" + createForm[i].value + "&";
            }
            // Reset all the form selections except category (as it doesn't make sense to show blank category)
            if (createForm[i].id != "category") {
                createForm[i].value = "";
            }
        }

        
        s_content += "dateTime=" + date + " " + time;

        console.log(s_content);
        // Send the new task to the server as a POST request with submission value set to createTask so it is identifiable as this kind of request
        var myRequest = new XMLHttpRequest();
        myRequest.open("POST", "/", true);
        myRequest.setRequestHeader("Content-type", "text/plain");
        myRequest.send("submission=createTask&" + s_content);
        // Call loadContent() (assumed to be in another javascript file for the respective page this is attached to)
        loadContent();
        getCategories(); // Refresh categories as well
    });
}

var shareObject = document.getElementById("shareForm")
var shareForm = document.getElementById("shareCategory");
var shareFormCategory = document.getElementById("categoryShare");

if (shareForm != null && shareFormCategory != null && shareObject != null) {
    
    // Node for show button that toggles the display of the form or not
    var showButtonNode = document.getElementById("displayShare");
    
    // True when the form should be visible the client, initially false (not showing)
    var showShare = false;

    // Define the behavior for the show button    
    showButtonNode.addEventListener("click", function() {
        if (!showShare) {
            // Hide the form object by moving it outside of visible range
            shareObject.style.top = -shareObject.style.height;
        }
        else {
            // Show by moving it down into visible range
            shareObject.style.top = shareObject.style.height;
        }
        // Set show variable to other state
        showShare = !showShare;
    });

    // Add event listener for the show button of the form to adjust the height when clicked
    // Add an event listener for when submit is activated and perform the POST request when it happens 
    shareForm.addEventListener("submit", async function(event) {
        // Preventing default reload request/expectation
        event.preventDefault();
        // Get the form object in the document
        var s_content = "categoryID=" +  shareForm[0].value + "&" + "username=" + shareForm[1].value

        // Send the new task to the server as a POST request with submission value set to createTask so it is identifiable as this kind of request
        var myRequest = new XMLHttpRequest();
        myRequest.open("POST", "/", true);
        myRequest.setRequestHeader("Content-type", "text/plain");
        myRequest.send("submission=shareCategory&" + s_content);
    });
}

// Initially show is false (set to hidden)
var categoryInputCreate = document.getElementById("categoryCreate");
var categoryInputShare = document.getElementById("categoryShare");
// Node for the form input that allows the user to create new category for their new task
var categoryText = document.getElementById("categoryText");
// Node for color selecting item in the file
var colorSelect = document.getElementById("color");

// Add an click listner for category input to dynamically show the category name text only when *New* option selected
if (categoryInputCreate != null) {
    // Set previousValue to be current intiially
    var previousValue = categoryInputCreate.value;
    categoryInputCreate.addEventListener("click", function(){
        // If the value has changed, then check the input value
        if (categoryInputCreate.value != previousValue) {
            // If new value is *New*, then show the categoryText and colorSelect inline
            if (categoryInputCreate.value == "*New*") {
                categoryText.style.display ="inline";
                colorSelect.style.display ="inline";
            }
            // If new value is not *New* (predefined category), then hide the categoryText and colorSelect items
            else if (previousValue == "*New*")  {
                categoryText.style.display ="none";
                colorSelect.style.display ="none";
            }
        }
        // Update previousValue to what the current value is
        previousValue = categoryInputCreate.value;
    });
}

// Function for adding categories into categoryInput tag for create Task form
function appendingCategories(content) {
    // Convert content to json format
    var jsonContent = JSON.parse(content);
    // Initially clear the content of the category and color select options
    categoryInputCreate.innerHTML = "";
    categoryInputShare.innerHTML = "";
    
    colorSelect.innerHTML = "";

    var categoryOption = document.createElement("OPTION");
    // Set new category to top for create form only
    categoryOption.setAttribute("value", "*New*");
    categoryOption.innerHTML = "*New*";
    categoryInputCreate.appendChild(categoryOption);

    // Append previous categories created
    for (i in jsonContent.category_options) {
        categoryOption = document.createElement("OPTION");
        categoryOption.setAttribute("value", jsonContent.category_options[jsonContent.category_options.length-1 - i].id); // The value is the category's associated ID
        categoryOption.innerHTML = jsonContent.category_options[jsonContent.category_options.length-1 - i].name;
        categoryInputCreate.appendChild(categoryOption);
        // Apeend not just to create form, but also to the share form's create slect list
        shareOption = document.createElement("OPTION");
        shareOption.setAttribute("value", jsonContent.category_options[jsonContent.category_options.length-1 - i].id); // The value is the category's associated ID
        shareOption.innerHTML = jsonContent.category_options[jsonContent.category_options.length-1 - i].name;
        categoryInputShare.appendChild(shareOption);
    }
    // Setting the available colors according to what the response contains
    for (i in jsonContent.color_options) {
        colorOption = document.createElement("OPTION");
        colorOption.setAttribute("value", jsonContent.color_options[i].option);
        colorOption.innerHTML = jsonContent.color_options[i].option;
        colorSelect.appendChild(colorOption);
    }
}

// A function called onload, gets categories from the server and appends to the forms for drop-down selection (data used in both createForm and shareForm)
async function getCategories() {
    // Set submission value to getCategories
    var request = "submission=getCategories";
    // Fetch the data and wait for response
    let data = await fetch(location.protocol + "//" + location.host, {
        method: 'POST',
        body: request,
    });
    if (!data.ok) {
        alert("Could not establish connection to server");
    }
    // If received the data okay, call outputTasks with the content
    else {
        data.text().then((content) => appendingCategories(content));
    }
}
