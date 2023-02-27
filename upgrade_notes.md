# Annex-IMS Upgrades

<details>
<summary>Upgrade Checklist Rails 5.2.8 -> 6.0.7</summary>

### Pre-upgrade

- [X]  Remove `vendor/gems`
- [X]  Finish relevant deprecation messages before upgrade
- [X]  Clean up bundle
- [X]  Upgrade RSPEC v. 5.0.0
- [X]  Abstract `FactoryBot.create` calls
- [X]  Passing tests

### Upgrade

- [X]  Run `bundle_report compatibility --rails-version=6.0.6` for incompatible gems
- [X]  Setup `next --init`, add conditional for rails upgrade, and upgrade bundle: `next bundle update`

**Rails Required Updates**

- [X]  Update Rails required per diff: [RailsDiffs](https://railsdiff.org/5.2.8/6.0.6)
- [X]  File diffs and `rails app:update`
- [X]  Passing Tests

### Post-Upgrade

- [X]  Remove `mini-racer` gem
- [X]  Update gems (see below)
- [ ]  Upgrade Sentry Raven gem (see below)

### Deprecations

**Rails**

- `app/assets/stylesheets/application.css`
  - [ ]  autoprefixer: `app/assets/stylesheets/application.css.scss:1194:3`: Gradient has outdated direction syntax. New syntax is like `to left` instead of `right`
  - [ ]  autoprefixer: `app/assets/stylesheets/application.css.scss:1233:3`: Gradient has outdated direction syntax. New syntax is like `to left` instead of `right`
  - [ ]  autoprefixer: `app/assets/stylesheets/application.css.scss:1251:3`: Gradient has outdated direction syntax. New syntax is like `to left` instead of `right`
  - [ ]  autoprefixer: `app/assets/stylesheets/application.css.scss:1281:3`: Gradient has outdated direction syntax. New syntax is like `to left` instead of `right`
  - [ ]  autoprefixer: `app/assets/stylesheets/application.css.scss:1465:3`: Gradient has outdated direction syntax. New syntax is like `to left` instead of `right`

**RSpec**

</details><br />

<details><summary>Upgrade Checklist Rails 6.0.6 -> 6.1.7</summary>

### Pre-upgrade

- [x]  Passing tests

### Upgrade

- [x]  Run `bundle_report compatibility --rails-version=6.1.7` for incompatible gems
- [x]  Add conditional for rails upgrade, and upgrade bundle: `next bundle update`

**Rails Required Updates**

- [x]  File diffs and `rails app:update`
- [x]  Update Rails required per diff: [RailsDiffs](https://railsdiff.org/6.0.6/6.1.7)
- [x]  Upgrade RSpec
- [x]  Passing Tests

### Post-Upgrade

- [x]  Update gems (see below)
- [x]  Fix OmniAuth vulnerability
- [x]  Fix jQuery vulnerability (upgrade to `jquery-rails` v. 4.4)

### Deprecations

**Rails**

**RSpec**

</details><br />

## Gem notes

- RSpec

  - [X]  v. 5.0.0    Rails 5.2, 6.0
  - [x]  v. 6.0.0    Rails 6.1, 7
- Coffee-Rails

  - [X]  v. 5.0.0 Rails >= 5.2

- [X]  Nokogiri

  - v. 1.11.0 adds Ruby 2.7 and 3.1 support
  - v. 1.13.0 adds Ruby 3.1 support
- [X]  PG v.1.4.2 to support Ruby 2.7.x keyword arg errors
- [X]  replace sentry-raven with `sentry-ruby` [Migration Guide](https://docs.sentry.io/platforms/ruby/migration/)
- [X]  `ice_cube` check out unreleased updates
- [X]  `recurring_select` is installed twice (remove vendor/gems)

- Rails 7

  - [ ]  `bootstrap_progressbar` will not need with Bootstrap5
  - [ ]  `bootstrap-datepicker-rails` replace with stimulus-flatpickr
  - [ ]  `multi-select-rails` - need replacement

  - `ffi`, `loofah`, and `bigdecimal` should disappear with upgrades
  - jquery-datatables-rails - abstract to Hotwire with Rails 7

### Not using

- progress_bar

## Security and Monitoring

- [ ]  Add RSpec reporter
- [ ]  Configure Linting and styling (Rubocop)
- [ ]  [Bundle Audit](https://github.com/rubysec/bundler-audit#readme)
