# LinkedIn Salary Helper

Tampermonkey script for LinkedIn job pages.

Setup:

1. Install `Tampermonkey`.
2. Open [linkedin-salary-helper.user.js](/home/user/repos/sergeia-resume-full-stack/tools/linkedin-salary-helper/linkedin-salary-helper.user.js).
3. Create a new Tampermonkey script and paste the file contents.
4. Open a LinkedIn job posting and click `Search salary`.

What it does:

- reads the current job title, company, and location
- builds a Google query like `Company Title Country salary`
- opens the search in a new tab

It only works on job pages you open manually.
