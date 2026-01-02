# newproject.sh - Project Setup Utility

## Overview

`newproject.sh` is a bash script that automates the creation of new research/data analysis projects with a standardized folder structure, conda environment setup, renv initialization, and git repository configuration.

## What It Does

When you run `newproject.sh`, it will:

1. **Create a standardized folder structure** with 9 directories:

   - `0_lit/` - Literature and references
   - `1_data/` - Data files
   - `2_scripts/` - Analysis scripts
   - `3_tabs/` - Tables
   - `4_figs/` - Figures and visualizations
   - `5_write/` - Writing and documentation
   - `6_present/` - Presentations
   - `99_misc/` - Miscellaneous files

2. **Initialize essential files**:

   - `.gitignore` - Pre-configured to ignore common data file types (`.csv`, `.dta`, `.xlsx`)
   - `Makefile` - Empty file ready for future template expansion
   - `README.md` - Empty file ready for project documentation

3. **Set up Python environment**:

   - Creates a conda environment with the same name as your project
   - Installs: Python, pandas, ipykernel, and tqdm

4. **Initialize R package management**:

   - Sets up renv for reproducible R package management
   - Creates `renv/` directory and `.Rprofile`

5. **Configure version control**:
   - Initializes a git repository
   - Sets up git configuration for the repository
   - Makes an initial commit
   - Provides instructions for connecting to GitHub (if desired)

## Prerequisites

Before using `newproject.sh`, ensure you have the following tools installed:

- **conda** - For Python environment management

  - Check: `conda --version`
  - Install: [Miniconda](https://docs.conda.io/en/latest/miniconda.html) or [Anaconda](https://www.anaconda.com/products/distribution)

- **R** - For R programming and renv

  - Check: `R --version`
  - Install: [CRAN](https://cran.r-project.org/)

- **git** - For version control
  - Check: `git --version`
  - Install: Usually pre-installed on macOS/Linux, or download from [git-scm.com](https://git-scm.com/)

**Note**: This script uses `git` commands only. It does not require the GitHub CLI (`gh`). To connect your repository to GitHub, you'll need to create the repository on GitHub manually and then add it as a remote.

## Installation

### Step 1: Download the Script

Copy `newproject.sh` to your desired location, or clone this repository.

### Step 2: Make It Executable

```bash
chmod +x newproject.sh
```

### Step 3: Install to Your PATH

To use `newproject` from anywhere, install it to a directory in your PATH:

```bash
# Create ~/bin if it doesn't exist
mkdir -p ~/bin

# Copy script to ~/bin
cp newproject.sh ~/bin/newproject
```

### Step 4: Add ~/bin to Your PATH

Add the following line to your shell configuration file:

**For zsh (macOS default):**

```bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**For bash:**

```bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Step 5: Verify Installation

Test that the script is accessible:

```bash
newproject --help
```

You should see the help documentation.

## Usage

### Interactive Mode

If you run `newproject` without arguments, it will prompt you for a project name:

```bash
newproject
```

### Direct Mode

Provide the project name as an argument:

```bash
newproject my-awesome-project
```

### Get Help

View detailed usage information:

```bash
newproject --help
```

## Project Name Restrictions

Project names must follow these rules to be compatible with directory names, conda environments, and git repositories:

- ✅ **Allowed**: Alphanumeric characters, hyphens (`-`), and underscores (`_`)
- ❌ **Not allowed**:
  - Spaces
  - Special characters: `/ \ : * ? " < > |`
  - Starting or ending with a hyphen (`-`) or dot (`.`)

**Valid examples:**

- `my-project`
- `my_project`
- `project123`
- `my-project_123`

**Invalid examples:**

- `my project` (contains space)
- `-myproject` (starts with hyphen)
- `myproject.` (ends with dot)
- `my/project` (contains slash)

## What Gets Created

After running `newproject.sh`, you'll have:

```
your-project-name/
├── 0_lit/
├── 1_data/
├── 2_scripts/
├── 3_tabs/
├── 4_figs/
├── 5_write/
├── 6_present/
├── 99_misc/
├── .gitignore
├── Makefile
├── README.md
├── .Rprofile
└── renv/
```

## Next Steps

After creating your project:

1. **Activate the conda environment**:

   ```bash
   conda activate your-project-name
   ```

2. **Navigate to your project**:

   ```bash
   cd your-project-name
   ```

3. **Start working**:

   - Add your data files to `1_data/`
   - Write scripts in `2_scripts/`
   - Create visualizations in `4_figs/`

4. **Connect to GitHub** (optional):
   If you want to push to GitHub, create a repository on GitHub first, then:
   ```bash
   git remote add origin https://github.com/your-username/your-project-name.git
   git branch -M main
   git push -u origin main
   ```

## Customization

### Modifying .gitignore

The `.gitignore` file is pre-configured to ignore common data file types. To track specific data files, you can:

1. Comment out the relevant line in `.gitignore`:

   ```gitignore
   # *.csv  # Uncomment to track CSV files
   ```

2. Or use `git add -f` to force-add specific files:
   ```bash
   git add -f 1_data/important_data.csv
   ```

### Adding Makefile Templates

The `Makefile` is initially empty. You can add common commands for your workflow, such as:

```makefile
.PHONY: clean install

install:
	conda env update -f environment.yml
	Rscript -e "renv::restore()"

clean:
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
```

## Troubleshooting

### Script Not Found

If you get `command not found: newproject`:

1. Verify `~/bin` is in your PATH:

   ```bash
   echo $PATH | grep "$HOME/bin"
   ```

2. Check the script exists:

   ```bash
   ls -l ~/bin/newproject
   ```

3. Reload your shell configuration:
   ```bash
   source ~/.zshrc  # or source ~/.bashrc
   ```

### Conda Environment Already Exists

If a conda environment with the same name exists, the script will ask if you want to recreate it. Answer `y` to recreate or `n` to skip.

### Directory Already Exists

If the project directory already exists, the script will exit with an error. Choose a different name or remove the existing directory first.

### renv Initialization Fails

If renv initialization fails, ensure:

- R is properly installed
- You have write permissions in the project directory
- The renv package is available (it will be installed automatically if needed)

## Contributing

To suggest improvements or report issues, please open an issue or submit a pull request.

## License

This script is provided as-is for personal and professional use.
