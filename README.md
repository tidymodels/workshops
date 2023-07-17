# workshops

This repo contains tutorial materials for machine learning with [tidymodels](https://www.tidymodels.org/).

## Organization

This repo is organized into directories:

-   `slides/` has Quarto files for the latest version of our slides.
-   `classwork/` contains Quarto files prepared for you to work along with the slides.
-   `archive/` is the location for older versions of this workshop.

## Code of Conduct

Please note that the workshops project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

[![CC BY-SA 4.0](https://licensebuttons.net/l/by-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-sa/4.0/)

## Archiving Notes

To archive previous workshop notes:

* Make a subdirectory in `archive/` called `YYYY-MM-workshop-name`.
* Copy the contents of `slides/` into `archive/YYYY-MM-workshop-name`.
* Copy the contents of `classwork/` into `archive/YYYY-MM-workshop-name`.
* Copy `index.qmd` into `archive/YYYY-MM-workshop-name`.
* In `_quarto.yml`:
	* add an entry `"archive/YYYY-MM-workshop-name/*qmd"` under `render`.
	* add an entry `"archive/YYYY-MM-workshop-name/classwork/*qmd"` under `resources`.
* In `archive/YYYY-MM-workshop-name/`, add a `_metadata.yml` file with the contents
```
execute:
  freeze: true
```
* In the command line, run `quarto render archive/YYYY-MM-workshop-name`. This will regenerate the workshop slides under `docs/archive/YYYY-MM-workshop-name`.
* Check that:
	* Running `quarto render` didn't change any files in `docs/` outside of `docs/archive/`.
	* The generated slides are added to `_freeze/archive/YYYY-MM-workshop-name` rather than in `archive/YYYY-MM-workshop-name`. 
	* The generated slides work (specifically, that filepaths to figures function correctly.)
* In `index.qmd`, add an entry in H2 "Past workshops" like `[M YYYY](archive/YYYY-MM-workshop-name/) in workshop-name`
