# Annex-IMS Upgrades

<details><summary>Upgrade Checklist Rails 5.2.8 -> 6.0.7</summary>

### Pre-upgrade

- [ ]  Finish deprecation messages before upgrade
- [ ]  Passing tests

### Upgrade

- [ ]  Run `bundle_report compatibility --rails-version=6.0.6` for incompatible gems
- [ ]  Setup `next --init`, add conditional for rails upgrade, and upgrade bundle: `next bundle update`

**Rails Required Updates**

- [X]  Update Rails required per diff: [RailsDiffs](https://railsdiff.org/5.2.8/6.0.6)
- [X]  File diffs and `rails app:update`
- [X]  Passing Tests

### Deprecations
**Rails**

**RSpec**

</details><br />

## Gem notes

- RSpec
  - [ ]  v. 4.1.0    Rails 5, 5.1
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
