/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

function openUserForm(event, formId) {
    event.preventDefault();

    document.getElementById(formId).style.display = "block";
}

function closeUserForm(formId) {
    document.getElementById(formId).style.display = "none";
}