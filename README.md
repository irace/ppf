# PPF

A script for helping bootstrap your weekly PPF. Currently supports integrating with:

* GitHub
* Clubhouse

## Usage

```bash
./bin/ppf               # Creates in the public folder for the upcoming week
./bin/ppf --private     # Creates in your private user folder
```

### Assumptions

This script assumes that you use Quip’s medium headings (aka `<h2>`) for your PPFs’ section headers, e.g. **Progress**, **Plans**, and **Fires**, and that **Plans** is always the second heading. Additionally, this script assumes that your **Plans** section is comprised of unordered list items (aka `li`).

## Configuration

First, you must create a `config.yml` file that includes the following values:

```yaml
user:
  first_name: Bryan

quip:
  api_token: <YOUR TOKEN HERE>

github:
  api_token: <YOUR TOKEN HERE>
  repository: prefer/iOS
  user_name: irace

clubhouse:
  api_token: <YOUR TOKEN HERE>
  owner_id: 57a4f19f-8f40-413f-888b-624c05b391ab
  workflow_state_ids: [500000011, 500000015]
```

You can create a GitHub API token [here](https://github.com/settings/tokens).
You can create a Clubhouse API token [here](https://app.clubhouse.io/prefer/settings/account/api-tokens).
You can create a Quip API token [here](https://interface.quip.com/api/personal-token).

### Template

You can customize `template.erb` in order to have your PPF come out looking like however you want it to
