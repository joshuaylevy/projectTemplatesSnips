#!/bin/bash

################################################################################
# newproject.sh - Project Setup Utility
#
# Creates a new project with standardized folder structure, conda environment,
# renv initialization, and git repository setup.
#
# Usage:
#   newproject [PROJECT_NAME]
#   newproject --help
#
# If PROJECT_NAME is not provided, the script will prompt interactively.
#
# Name Restrictions:
#   - Must contain only alphanumeric characters, hyphens, and underscores
#   - Cannot start or end with a hyphen or dot
#   - Cannot contain spaces or special characters: / \ : * ? " < > |
#   - Must be valid for: directory names, conda environment names, git repo names
#
# Prerequisites:
#   - conda (for Python environment management)
#   - R (for renv initialization)
#   - git (for version control)
#
# Installation:
#   1. Make script executable: chmod +x newproject.sh
#   2. Install to ~/bin: cp newproject.sh ~/bin/newproject
#   3. Ensure ~/bin is in your PATH (add to ~/.zshrc or ~/.bashrc):
#      export PATH="$HOME/bin:$PATH"
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
}

success() {
    echo -e "${GREEN}✓ $1${NC}" >&2
}

info() {
    echo -e "${BLUE}ℹ $1${NC}" >&2
}

warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Help function
show_help() {
    cat << EOF
newproject - Project Setup Utility

Creates a new project with standardized folder structure, conda environment,
renv initialization, and git repository setup.

USAGE:
    newproject [PROJECT_NAME] [OPTIONS]
    newproject --help

ARGUMENTS:
    PROJECT_NAME    Name of the project (optional, will prompt if not provided)

OPTIONS:
    -h, --help      Show this help message

NAME RESTRICTIONS:
    Project names must:
    - Contain only alphanumeric characters, hyphens (-), and underscores (_)
    - Not start or end with a hyphen (-) or dot (.)
    - Not contain spaces or special characters: / \\ : * ? " < > |
    - Be valid for directory names, conda environment names, and git repository names

    Examples of valid names:
    - my-project
    - my_project
    - project123
    - my-project_123

    Examples of invalid names:
    - my project (contains space)
    - -myproject (starts with hyphen)
    - myproject. (ends with dot)
    - my/project (contains slash)

WHAT THIS SCRIPT CREATES:
    1. Directory structure:
       - 0_lit/      (literature)
       - 1_data/     (data files)
       - 2_scripts/  (scripts)
       - 3_tabs/     (tables)
       - 4_figs/     (figures)
       - 5_write/    (writing)
       - 6_present/  (presentations)
       - 99_misc/    (miscellaneous)
    
    2. Initial files:
       - .gitignore  (with data file patterns: *.csv, *.dta, *.xlsx)
       - Makefile    (empty, ready for future template expansion)
       - README.md   (empty)
    
    3. Conda environment: <PROJECT_NAME>
       - Python
       - pandas
       - ipykernel
       - tqdm
    
    4. renv initialization (R package management)
    
    5. Git repository initialized (ready to connect to GitHub)

PREREQUISITES:
    The following tools must be installed and available in your PATH:
    - conda    (Python environment management)
    - R        (R programming language)
    - git      (version control)

    To check if prerequisites are installed:
    - conda --version
    - R --version
    - git --version

INSTALLATION:
    1. Make script executable:
       chmod +x newproject.sh
    
    2. Install to ~/bin:
       cp newproject.sh ~/bin/newproject
    
    3. Ensure ~/bin is in your PATH (add to ~/.zshrc or ~/.bashrc):
       export PATH="\$HOME/bin:\$PATH"
    
    4. Reload your shell configuration:
       source ~/.zshrc  # or source ~/.bashrc

EXAMPLES:
    # Interactive mode (will prompt for project name):
    newproject
    
    # Direct mode (provide project name):
    newproject my-awesome-project
    
    # Show help:
    newproject --help

EOF
}

# Validate project name
validate_project_name() {
    local name="$1"
    
    if [[ -z "$name" ]]; then
        error "Project name cannot be empty"
        return 1
    fi
    
    # Check for spaces
    if [[ "$name" =~ [[:space:]] ]]; then
        error "Project name cannot contain spaces"
        return 1
    fi
    
    # Check for invalid special characters
    # Store pattern in variable to avoid shell interpretation issues
    local invalid_chars_pattern='[/\\:*?"<>|]'
    if [[ "$name" =~ $invalid_chars_pattern ]]; then
        error "Project name cannot contain special characters: / \\ : * ? \" < > |"
        return 1
    fi
    
    # Check for leading/trailing dots or hyphens
    if [[ "$name" =~ ^[-.] ]] || [[ "$name" =~ [-.]$ ]]; then
        error "Project name cannot start or end with a hyphen (-) or dot (.)"
        return 1
    fi
    
    # Check that name contains only valid characters (alphanumeric, hyphens, underscores)
    if [[ ! "$name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        error "Project name can only contain alphanumeric characters, hyphens, and underscores"
        return 1
    fi
    
    return 0
}

# Check prerequisites
check_prerequisites() {
    info "Checking prerequisites..."
    
    local missing=0
    
    if ! command -v conda &> /dev/null; then
        error "conda is not installed or not in PATH"
        missing=1
    fi
    
    if ! command -v R &> /dev/null; then
        error "R is not installed or not in PATH"
        missing=1
    fi
    
    if ! command -v git &> /dev/null; then
        error "git is not installed or not in PATH"
        missing=1
    fi
    
    if [[ $missing -eq 1 ]]; then
        error "Please install missing prerequisites before running this script"
        return 1
    fi
    
    success "All prerequisites found"
    return 0
}

# Create project structure
create_project_structure() {
    local project_name="$1"
    local project_dir="$PWD/$project_name"
    
    info "Creating project directory: $project_dir"
    
    # Check if directory already exists
    if [[ -d "$project_dir" ]]; then
        error "Directory '$project_dir' already exists"
        warning "Please choose a different project name or remove the existing directory"
        return 1
    fi
    
    # Create main project directory
    mkdir -p "$project_dir"
    success "Created project directory"
    
    # Create subdirectories
    info "Creating folder structure..."
    mkdir -p "$project_dir/0_lit"
    mkdir -p "$project_dir/1_data"
    mkdir -p "$project_dir/2_scripts"
    mkdir -p "$project_dir/3_tabs"
    mkdir -p "$project_dir/4_figs"
    mkdir -p "$project_dir/5_write"
    mkdir -p "$project_dir/6_present"
    mkdir -p "$project_dir/99_misc"
    success "Created folder structure"
    
    # Create .gitignore
    info "Creating .gitignore..."
    cat > "$project_dir/.gitignore" << 'GITIGNORE_EOF'
# Data files (uncomment specific lines to track them)
*.csv
*.dta
*.xlsx
GITIGNORE_EOF
    success "Created .gitignore"
    
    # Create empty Makefile
    info "Creating Makefile..."
    touch "$project_dir/Makefile"
    success "Created Makefile"
    
    # Create empty README.md
    info "Creating README.md..."
    touch "$project_dir/README.md"
    success "Created README.md"
    
    echo "$project_dir"
}

# Create conda environment
create_conda_environment() {
    local project_name="$1"
    
    info "Creating conda environment: $project_name"
    
    # Check if environment already exists
    if conda env list | grep -q "^$project_name "; then
        warning "Conda environment '$project_name' already exists"
        read -p "Do you want to recreate it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            info "Skipping conda environment creation"
            return 0
        fi
        conda env remove -n "$project_name" -y || true
    fi
    
    conda create -n "$project_name" python pandas ipykernel tqdm -y || {
        error "Failed to create conda environment"
        return 1
    }
    
    success "Created conda environment: $project_name"
    info "To activate: conda activate $project_name"
}

# Initialize renv
initialize_renv() {
    local project_dir="$1"
    
    info "Initializing renv..."
    
    # Change to project directory
    cd "$project_dir" || {
        error "Failed to change to project directory"
        return 1
    }
    
    # Initialize renv with environment isolation
    # Use --vanilla to prevent loading any .Rprofile files (parent or current)
    # This ensures renv can initialize cleanly even when run from within an renv project
    local renv_output
    renv_output=$(R --vanilla --slave --no-restore --no-save -e "renv::init(bare = TRUE)" 2>&1)
    local renv_exit_code=$?
    
    if [[ $renv_exit_code -ne 0 ]]; then
        error "Failed to initialize renv"
        error "Error output: $renv_output"
        return 1
    fi
    
    success "Initialized renv"
    
    # Create comprehensive .Rprofile
    info "Creating .Rprofile..."
    cat > "$project_dir/.Rprofile" << 'RPROFILE_EOF'
source("renv/activate.R")
### print current working directory of R instance
print("#############################################################################")
print(paste("Loading local custom .Rprofile:", getwd(), "/.Rprofile", sep = ""))
print(paste("CURRENT WORKING DIRECTORY:", getwd(), sep = " "))
print("#############################################################################")



### setting CRAN mirror default
local({
    r <- getOption("repos")
    r["CRAN"] <- "https://cran.rstudio.com/"
    options(repos = r)
})
Sys.setenv(RGL_USE_NULL = TRUE)

## Optional: print to confirm
print("renv external.libraries set to:")
print(renv::settings$external.libraries())

### httpgd plot viewer setup
options(vsc.plot = FALSE)
if (interactive() && Sys.getenv("TERM_PROGRAM") == "vscode") {
    if ("httpgd" %in% .packages(all.available = TRUE)) {
        options(vsc.plot = FALSE)
        options(device = function(...) {
            httpgd::hgd(silent = TRUE)
            .vsc.browser(httpgd::hgd_url(history = FALSE), viewer = "Beside")
        })
    }
}

## loading custom fonts
# NOTE: For replication packages, copy font files to project directory and update paths
# Font files should be copied from: /Users/joshuaylevy/Documents/Work/General/projectTemplatesSnips/theme_personal/fonts/
inter_font_load <- function() {
    tryCatch(
        {
            sysfonts::font_add(
                family = "Inter",
                regular = "/Users/joshuaylevy/Documents/Work/General/projectTemplatesSnips/theme_personal/fonts/Inter-Regular.ttf",
                bold = "/Users/joshuaylevy/Documents/Work/General/projectTemplatesSnips/theme_personal/fonts/Inter-Bold.ttf",
                italic = "/Users/joshuaylevy/Documents/Work/General/projectTemplatesSnips/theme_personal/fonts/Inter-Light.ttf"
            )
        },
        warning = function(w) {
            message("WARNING: Custom font ('Inter') failed to load properly. Custom themes may not load properly")
        }
    )
}
inter_font_load()

intel_font_load <- function() {
    tryCatch(
        {
            sysfonts::font_add(
                family = "Intel One",
                regular = "/Users/joshuaylevy/Documents/Work/General/projectTemplatesSnips/theme_personal/fonts/intelone-mono-font-family-regular.ttf",
                bold = "/Users/joshuaylevy/Documents/Work/General/projectTemplatesSnips/theme_personal/fonts/intelone-mono-font-family-bold.ttf",
                italic = "/Users/joshuaylevy/Documents/Work/General/projectTemplatesSnips/theme_personal/fonts/intelone-mono-font-family-italic.ttf"
            )
        },
        warning = function(w) {
            message("WARNING: Custom font ('Intel One') failed to load properly. Custom themes may not load properly")
        }
    )
}
intel_font_load()

### loading personal theme for dataviz
# NOTE: For replication packages, copy theme_personal.R to project directory and update path
# Copy from: /Users/joshuaylevy/Documents/Work/General/projectTemplatesSnips/theme_personal/r_materials/theme_personal.R
source("/Users/joshuaylevy/Documents/Work/General/projectTemplatesSnips/theme_personal/r_materials/theme_personal.R")
RPROFILE_EOF
    
    success "Created .Rprofile"
    
    # Return to original directory
    cd - > /dev/null || true
}

# Initialize git repository
setup_git() {
    local project_dir="$1"
    local project_name="$2"
    
    info "Setting up git repository..."
    
    # Change to project directory
    cd "$project_dir" || {
        error "Failed to change to project directory"
        return 1
    }
    
    # Initialize git
    git init || {
        error "Failed to initialize git repository"
        return 1
    }
    success "Initialized git repository"
    
    # Make initial commit
    info "Making initial commit..."
    git add . || {
        error "Failed to stage files"
        return 1
    }
    
    # Configure git user if not already configured (for this repo)
    # Use global config if available, otherwise set defaults
    if ! git config user.name &> /dev/null; then
        if git config --global user.name &> /dev/null; then
            git config user.name "$(git config --global user.name)"
        else
            warning "Git user.name not configured. Set it with: git config user.name 'Your Name'"
        fi
    fi
    
    if ! git config user.email &> /dev/null; then
        if git config --global user.email &> /dev/null; then
            git config user.email "$(git config --global user.email)"
        else
            warning "Git user.email not configured. Set it with: git config user.email 'your.email@example.com'"
        fi
    fi
    
    git commit -m "Initial commit" || {
        error "Failed to create initial commit"
        return 1
    }
    success "Created initial commit"
    
    # Determine default branch name (main or master)
    local default_branch
    default_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")
    
    info "Git repository initialized on branch: $default_branch"
    info "To connect to GitHub, create a repository on GitHub and run:"
    info "  git remote add origin https://github.com/your-username/$project_name.git"
    info "  git push -u origin $default_branch"
    
    # Return to original directory
    cd - > /dev/null || true
}

# Main function
main() {
    local project_name=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                if [[ -z "$project_name" ]]; then
                    project_name="$1"
                else
                    error "Unexpected argument: $1"
                    echo "Use --help for usage information"
                    exit 1
                fi
                ;;
        esac
        shift
    done
    
    # If no project name provided, prompt interactively
    if [[ -z "$project_name" ]]; then
        echo
        info "Interactive mode: No project name provided"
        read -p "Enter project name: " project_name
        echo
    fi
    
    # Validate project name
    if ! validate_project_name "$project_name"; then
        echo
        echo "Use --help for usage information and name restrictions"
        exit 1
    fi
    
    # Check prerequisites
    if ! check_prerequisites; then
        exit 1
    fi
    
    echo
    info "Starting project setup for: $project_name"
    echo
    
    # Create project structure
    local project_dir
    project_dir=$(create_project_structure "$project_name") || exit 1
    
    # Create conda environment
    create_conda_environment "$project_name" || {
        warning "Conda environment creation failed, but continuing..."
    }
    
    # Initialize renv
    initialize_renv "$project_dir" || {
        warning "renv initialization failed, but continuing..."
    }
    
    # Setup git repository
    setup_git "$project_dir" "$project_name" || {
        warning "Git setup failed, but continuing..."
    }
    
    echo
    success "Project setup complete!"
    echo
    info "Project directory: $project_dir"
    info "To activate conda environment: conda activate $project_name"
    info "To navigate to project: cd $project_dir"
    echo
}

# Run main function
main "$@"

