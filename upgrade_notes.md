# Annex-IMS Upgrades

<details><summary>Upgrade Checklist Rails 5.2.8 -> 6.0.7</summary>

### Pre-upgrade

- [x] Remove `vendor/gems`
- [x] Finish relevant deprecation messages before upgrade
- [x] Clean up bundle 
- [x] Upgrade RSPEC v. 5.0.0
- [x] Abstract `FactoryBot.create` calls
- [ ] Passing tests

### Upgrade

- [x]  Run `bundle_report compatibility --rails-version=6.0.6` for incompatible gems
- [x]  Setup `next --init`, add conditional for rails upgrade, and upgrade bundle: `next bundle update`

**Rails Required Updates**

- [ ]  Update Rails required per diff: [RailsDiffs](https://railsdiff.org/5.2.8/6.0.6)
- [ ]  File diffs and `rails app:update`
- [ ]  Passing Tests

### Deprecations
**Rails**

- `app/assets/stylesheets/application.css`
  - [ ] autoprefixer: `app/assets/stylesheets/application.css.scss:1194:3`: Gradient has outdated direction syntax. New syntax is like `to left` instead of `right`
  - [ ] autoprefixer: `app/assets/stylesheets/application.css.scss:1233:3`: Gradient has outdated direction syntax. New syntax is like `to left` instead of `right`
  - [ ] autoprefixer: `app/assets/stylesheets/application.css.scss:1251:3`: Gradient has outdated direction syntax. New syntax is like `to left` instead of `right`
  - [ ] autoprefixer: `app/assets/stylesheets/application.css.scss:1281:3`: Gradient has outdated direction syntax. New syntax is like `to left` instead of `right`
  - [ ] autoprefixer: `app/assets/stylesheets/application.css.scss:1465:3`: Gradient has outdated direction syntax. New syntax is like `to left` instead of `right`

**RSpec**

</details><br />

## Gem notes

- RSpec
  - [ ]  v. 5.0.0    Rails 5.2, 6.0
  - [ ]  v. 6.0.0    Rails 6.1, 7
  
- Coffee-Rails
  - [ ]  v. 5.0.0 Rails >= 5.2

- [ ] Nokogiri
  - v. 1.11.0 adds Ruby 2.7 and 3.1 support
  - v. 1.13.0 adds Ruby 3.1 support
- [ ] PG v.1.4.2 to support Ruby 2.7.x keyword arg errors

- [ ] replace sentry-raven with `sentry-ruby` [Migration Guide](https://docs.sentry.io/platforms/ruby/migration/)
- [ ] `ice_cube` check out unreleased updates
- [ ] `recurring_select` is installed twice (vendor/gems)

- Rails 7
  - [ ] `bootstrap_progressbar` will not need with Bootstrap5
  - [ ] `bootstrap-datepicker-rails` replace with stimulus-flatpickr
  - [ ] `multi-select-rails` - need replacement
  - `ffi`, `loofah`, and `bigdecimal` should disappear with upgrades
  - jquery-datatables-rails - abstract to Hotwire with Rails 7 (breaks @ 6.1)

### Not using
- progress_bar

## Security and Monitoring
- [ ]  Add RSpec reporter
- [ ]  Add `simplecov`
- [ ]  Configure Linting and styling (Rubocop)
- [ ]  [Bundle Audit](https://github.com/rubysec/bundler-audit#readme)
