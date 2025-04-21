'use strict';

// element toggle function
const elementToggleFunc = function (elem) {
  elem.classList.toggle("active");
};

// sidebar toggle (optional, if sidebar exists)
const sidebar = document.querySelector("[data-sidebar]");
const sidebarBtn = document.querySelector("[data-sidebar-btn]");
if (sidebarBtn && sidebar) {
  sidebarBtn.addEventListener("click", function () {
    elementToggleFunc(sidebar);
  });
}

// custom select box logic
const select = document.querySelector("[data-select]");
const selectItems = document.querySelectorAll("[data-select-item]");
const selectValue = document.querySelector("[data-select-value]");
const filterBtns = document.querySelectorAll("[data-filter-btn]");
const filterItems = document.querySelectorAll("[data-filter-item]");

// toggle dropdown
select.addEventListener("click", function () {
  elementToggleFunc(this);
});

// handle filter function
const filterFunc = function (selectedCategory) {
  filterItems.forEach(item => {
    const itemCategory = item.dataset.category;
    if (selectedCategory === "all" || itemCategory === selectedCategory) {
      item.classList.add("active");
    } else {
      item.classList.remove("active");
    }
  });
};

// select dropdown items
selectItems.forEach(item => {
  item.addEventListener("click", function () {
    const selectedCategory = this.dataset.category;
    const label = this.innerText;
    selectValue.innerText = label;
    elementToggleFunc(select);
    filterFunc(selectedCategory);
    // sync with filter buttons
    filterBtns.forEach(btn => {
      btn.classList.toggle("active", btn.dataset.category === selectedCategory);
    });
  });
});

// large screen filter buttons
let lastClickedBtn = filterBtns[0];

filterBtns.forEach(btn => {
  btn.addEventListener("click", function () {
    const selectedCategory = this.dataset.category;
    const label = this.innerText;
    selectValue.innerText = label;
    filterFunc(selectedCategory);

    lastClickedBtn.classList.remove("active");
    this.classList.add("active");
    lastClickedBtn = this;
  });
});


const form = document.querySelector("[data-form]");
const formInputs = document.querySelectorAll("[data-form-input]");
const formBtn = document.querySelector("[data-form-btn]");

// ✅ Replace with your actual Web App URL
const scriptURL = "https://script.google.com/macros/s/AKfycbxXa_IHt0Hc6o9u3m8iTZUBr8mbEvIE2ZFTcifbKSPvSC1TMOqD28nzUnvp1iVvjYKYSw/exec";

// Enable/disable submit button based on form validity
formInputs.forEach(input => {
  input.addEventListener("input", () => {
    formBtn.disabled = !form.checkValidity();
  });
});

// Submit form data
form.addEventListener("submit", e => {
  e.preventDefault();

  const formData = new FormData(form);

  fetch(scriptURL, {
    method: "POST",
    body: formData
  })
    .then(response => response.json())
    .then(data => {
      if (data.result === "success") {
        alert("Message sent successfully!");
        form.reset();
        formBtn.disabled = true;
      } else {
        alert("Failed to send message.");
      }
    })
    .catch(error => {
      console.error("Error!", error.message);
      alert("Error sending message.");
    });
});



// page navigation variables
const navigationLinks = document.querySelectorAll("[data-nav-link]");
const pages = document.querySelectorAll("[data-page]");

// add event to all nav link
for (let i = 0; i < navigationLinks.length; i++) {
  navigationLinks[i].addEventListener("click", function () {

    for (let i = 0; i < pages.length; i++) {
      if (this.innerHTML.toLowerCase() === pages[i].dataset.page) {
        pages[i].classList.add("active");
        navigationLinks[i].classList.add("active");
        window.scrollTo(0, 0);
      } else {
        pages[i].classList.remove("active");
        navigationLinks[i].classList.remove("active");
      }
    }

  });
}