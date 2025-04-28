# 💌 The Suitor's Proposal
A Brown/RISD Game Developers production for Spring 2025.

## Technical Stack
* **Engine:** [Godot 4.4.1](https://godotengine.org/download/archive/)

## Project Setup
1. Install Godot 4.4.1 from the [Godot website](https://godotengine.org/download/archive/).
2. Clone this repository to your local machine.
3. Open Godot on your machine. Click `Import` at the top and navigate to the project folder, wherever you saved it.
4. The project should show up. Double click it to open it.

## Workflow
This project uses branches when creating new features or fixing bugs. Editing the `main` branch is heavily discouraged. Rather, please create pull requests when new changes are ready to be pushed into the project.

Instructions for creating new branches:
1. Run `git checkout main && git pull` to update your local `main` branch and ensure you have the latest updates.
2. Run `git checkout -b <branch-name>` to create a new branch. The conventional branch name is `feature/feature-name` or `bugfix/bug-fix-name`. Hyphenate words in the branch name instead of using spaces.
3. Make your changes, and commit them to the branch.
4. Run `git push` when you are ready. You may be asked to set the upstream. Copy and paste the command that is provided to you.
5. Go onto Github and create a pull request. If it can automatically be merged into `main`, merge it and close the request. Otherwise, ask for additional help!