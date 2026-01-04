# ============================================
# GOVT 10 Setup Script
# Run this entire script to set up your environment
# ============================================

# --- 1. Install R Packages ---
cat("Installing R packages...\n")
install.packages("tidyverse")
install.packages("knitr")
install.packages("formatR")
install.packages("rstudioapi")
install.packages("broom")
install.packages("quarto")
install.packages("lubridate")
install.packages("patchwork")
install.packages("tinytex")
install.packages("jsonlite")

# --- 2. Install TinyTeX for PDF rendering ---
cat("Installing TinyTeX...\n")
tinytex::install_tinytex()
tinytex::tlmgr_update()

# --- 3. Check for Git and Configure Positron ---
cat("\n=== Checking for Git ===\n")

git_path <- Sys.which("git")

if (nchar(git_path) == 0) {
  cat("Git is NOT installed.\n\n")

  os <- Sys.info()["sysname"]

  if (os == "Darwin") {
    cat("To install Git on macOS, run this in Terminal:\n")
    cat("  xcode-select --install\n\n")
  } else if (os == "Windows") {
    cat("Download Git from: https://git-scm.com/download/win\n\n")
  } else {
    cat("Install Git with: sudo apt install git\n\n")
  }
  cat("After installing Git, restart R and re-run this script.\n")
} else {
  cat("Git found at:", git_path, "\n")

  # Configure Positron to use this Git
  cat("Configuring Positron to use Git...\n")

  os <- Sys.info()["sysname"]
  if (os == "Darwin" || os == "Linux") {
    settings_dir <- file.path(Sys.getenv("HOME"), ".config", "Positron", "User")
  } else {
    settings_dir <- file.path(Sys.getenv("APPDATA"), "Positron", "User")
  }
  settings_file <- file.path(settings_dir, "settings.json")

  # Create directory if it doesn't exist
  if (!dir.exists(settings_dir)) {
    dir.create(settings_dir, recursive = TRUE)
  }

  # Read existing settings or create new
  if (file.exists(settings_file)) {
    settings <- jsonlite::fromJSON(settings_file)
  } else {
    settings <- list()
  }

  # Add git.path
  settings[["git.path"]] <- as.character(git_path)

  # Write settings back
  jsonlite::write_json(settings, settings_file, pretty = TRUE, auto_unbox = TRUE)

  cat("Positron configured to use Git at:", git_path, "\n")
  cat("Settings saved to:", settings_file, "\n")
}

cat("\n=== Setup Complete! ===\n")
cat("Please restart Positron for changes to take effect.\n")
