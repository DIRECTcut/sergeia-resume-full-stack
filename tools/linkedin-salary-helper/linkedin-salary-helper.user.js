// ==UserScript==
// @name         LinkedIn Salary Helper
// @namespace    sergeia-resume-full-stack
// @version      0.1.0
// @description  Add a salary-search button to LinkedIn job pages using the current vacancy details.
// @match        https://www.linkedin.com/jobs/view/*
// @match        https://www.linkedin.com/jobs/collections/*
// @match        https://www.linkedin.com/jobs/search-results/*
// @grant        GM_openInTab
// ==/UserScript==

(function () {
  "use strict";

  const BUTTON_ID = "sa-linkedin-salary-helper";
  const WRAPPER_ID = "sa-linkedin-salary-helper-wrapper";

  function textFromSelectors(selectors) {
    for (const selector of selectors) {
      const node = document.querySelector(selector);
      const text = node?.textContent?.trim();
      if (text) return text;
    }
    return "";
  }

  function normalizeLocation(raw) {
    return raw
      .split(/·|\||,/)
      .map((part) => part.trim())
      .filter(Boolean)
      .slice(0, 2)
      .join(" ");
  }

  function parseTitleFallback() {
    const rawTitle = document.title.replace(/\s*\|\s*LinkedIn\s*$/i, "").trim();
    if (!rawTitle) return { title: "", company: "", location: "" };

    const parts = rawTitle.split("|").map((part) => part.trim()).filter(Boolean);
    const left = parts[0] || "";
    const company = parts[1] || "";

    if (!left) return { title: "", company, location: "" };

    const bits = left.split(",").map((part) => part.trim()).filter(Boolean);
    if (bits.length >= 2) {
      return {
        title: bits.slice(0, -1).join(", "),
        company,
        location: bits.slice(-1)[0]
      };
    }

    return { title: left, company, location: "" };
  }

  function escapeRegExp(value) {
    return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  }

  function getSelectedCardFallback(title, company) {
    const titlePattern = title ? new RegExp(escapeRegExp(title), "i") : null;
    const companyPattern = company ? new RegExp(escapeRegExp(company), "i") : null;
    const cards = Array.from(document.querySelectorAll("div, li, article"));

    for (const card of cards) {
      const text = (card.textContent || "").trim().replace(/\s+/g, " ");
      if (!text || text.length > 220) continue;
      if (!/Selected,/i.test(text)) continue;
      if (titlePattern && !titlePattern.test(text)) continue;
      if (companyPattern && !companyPattern.test(text)) continue;

      const pieces = Array.from(card.querySelectorAll("p, span, div, a"))
        .map((node) => (node.textContent || "").trim())
        .filter(Boolean)
        .filter((value, index, arr) => arr.indexOf(value) === index);

      const locationFromPieces = pieces.find((value) => {
        if (/^selected,/i.test(value)) return false;
        if (titlePattern && titlePattern.test(value)) return false;
        if (companyPattern && companyPattern.test(value)) return false;
        if (/verified job|under \d+ applicants|easy apply/i.test(value)) return false;
        return true;
      }) || "";

      if (locationFromPieces) {
        return { location: locationFromPieces };
      }

      const compactText = text.replace(/\(Verified job\)/gi, " ");
      const companyIndex = company ? compactText.toLowerCase().lastIndexOf(company.toLowerCase()) : -1;
      if (companyIndex >= 0) {
        const tail = compactText
          .slice(companyIndex + company.length)
          .replace(/^[\s,·|:-]+/, "")
          .trim();

        if (tail) {
          const locationMatch = tail.match(/^(Remote|Hybrid|On-site|[A-Z][A-Za-z]+(?:\s+[A-Z][A-Za-z]+){0,3})/);
          if (locationMatch) {
            return { location: locationMatch[1] };
          }
        }
      }

      return { location: "" };
    }

    return { location: "" };
  }

  function getVacancyData() {
    const fallback = parseTitleFallback();

    const title = textFromSelectors([
      "h1.t-24",
      ".job-details-jobs-unified-top-card__job-title h1",
      ".jobs-unified-top-card__job-title h1",
      "h1"
    ]) || fallback.title;

    const company = textFromSelectors([
      ".job-details-jobs-unified-top-card__company-name a",
      ".job-details-jobs-unified-top-card__company-name",
      ".jobs-unified-top-card__company-name a",
      ".jobs-unified-top-card__company-name"
    ]) || fallback.company;

    const selectedCardFallback = getSelectedCardFallback(title, company);

    const location = normalizeLocation(textFromSelectors([
      ".job-details-jobs-unified-top-card__primary-description-container",
      ".jobs-unified-top-card__primary-description-container",
      ".jobs-unified-top-card__subtitle-primary-grouping",
      ".jobs-unified-top-card__bullet"
    ])) || selectedCardFallback.location || fallback.location;

    return { title, company, location };
  }

  function buildQuery() {
    const { title, company, location } = getVacancyData();
    return [company, title, location, "salary"]
      .filter(Boolean)
      .join(" ")
      .replace(/\s+/g, " ")
      .trim();
  }

  function openSalarySearch() {
    const query = buildQuery();
    if (!query) return;
    const url = `https://www.google.com/search?q=${encodeURIComponent(query)}`;
    if (typeof GM_openInTab === "function") {
      GM_openInTab(url, { active: false, insert: true });
      return;
    }
    window.open(url, "_blank", "noopener");
  }

  function findActionContainer() {
    const saveButton = Array.from(document.querySelectorAll("button, a")).find((node) => {
      const label = `${node.textContent || ""} ${node.getAttribute("aria-label") || ""}`;
      return /save the job|^save$/i.test(label.trim());
    });

    const applyButton = Array.from(document.querySelectorAll("button, a")).find((node) => {
      const label = `${node.textContent || ""} ${node.getAttribute("aria-label") || ""}`;
      return /apply/i.test(label);
    });

    return saveButton?.parentElement?.parentElement || applyButton?.parentElement?.parentElement || null;
  }

  function ensureButton() {
    const query = buildQuery();
    if (!query) return;

    let button = document.getElementById(BUTTON_ID);
    if (!button) {
      button = document.createElement("button");
      button.id = BUTTON_ID;
      button.type = "button";
      button.textContent = "Search salary";
      button.addEventListener("click", openSalarySearch);
      Object.assign(button.style, {
        padding: "10px 14px",
        border: "1px solid #0a66c2",
        borderRadius: "999px",
        background: "#0a66c2",
        color: "#fff",
        fontSize: "14px",
        fontWeight: "600",
        cursor: "pointer",
        boxShadow: "0 6px 18px rgba(0, 0, 0, 0.18)"
      });
    }

    button.title = query;

    const actionContainer = findActionContainer();
    if (actionContainer) {
      let wrapper = document.getElementById(WRAPPER_ID);
      if (!wrapper) {
        wrapper = document.createElement("div");
        wrapper.id = WRAPPER_ID;
        wrapper.setAttribute("style", "display:inline-flex; align-items:center; margin-left:8px;");
      }

      button.style.position = "static";
      button.style.right = "";
      button.style.bottom = "";
      button.style.zIndex = "";
      button.style.marginLeft = "0";
      if (button.parentElement !== wrapper) {
        wrapper.appendChild(button);
      }
      if (wrapper.parentElement !== actionContainer) {
        actionContainer.appendChild(wrapper);
      }
      return;
    }

    button.style.position = "fixed";
    button.style.right = "20px";
    button.style.bottom = "20px";
    button.style.zIndex = "99999";
    button.style.marginLeft = "0";
    if (button.parentElement !== document.body) {
      document.body.appendChild(button);
    }
  }

  const observer = new MutationObserver(() => {
    ensureButton();
  });

  observer.observe(document.documentElement, { childList: true, subtree: true });
  ensureButton();
})();
