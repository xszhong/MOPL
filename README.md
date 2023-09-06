# MOPL
Codes and datasets of our Knowledge-Based Systems paper: Marshall-Olkin Power-Law Distributions in Length-Frequency of Entities

## File Structure

```bash
.
├── README.md
├── code
│   ├── MOPL.R  # MOPL fit fuction, fit results were saved in /result
│   └── MOPL_draw.py  # draw MOPL fit results
├── data  # raw data, no fit yet
│   ├── different_languages/
│   └── different_types/
├── image  # MOPL fit graph
│   ├── different_types/
│   └── differnet_languages/
└── result
    ├── MOPL_languages.csv  # MOPL fit parameters
    ├── MOPL_types.csv  # MOPL fit parameters
    ├── different_languages/  # MOPL fit results
    └── different_types/. # MOPL fit results
```



## Requirements:

**Python:**

```bash
python -m pip install -U pip
python -m pip install -U matplotlib
pip install numpy
```

**R:**

```R
install.packages("zipfextR")
install.packages("ggplot2")
```



## Run

1. Run `MOPL.R`
2. Run `MOPL_draw.py`


## Publication
Xiaoshi Zhong, Xiang Yu, Erik Cambria, and Jagath C. Rajapakse. Marshall-Olkin Power-Law Distributions in Length-Frequency of Entities. To appear in *Knowledge-Based Systems*, 2023.