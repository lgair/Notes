#Chronos 12 platform Production Calibration App Software Release Process.

---

1. Develop the changes and fixes required for an update.
    1. Develop appropriate unit tests & integration tests for new features
       etc. (TODO - Maybe Implement Qt tests?).
2. Run Tests, repeat step one until tests are satisfied.
3. Once Testing has passed, perform functional tests to ensure application
   is behaving as intended from the users perspective. (develop
   qTest/gTest).
    1. Once Funtional tests are satisfactory, move on else repeat step
       three.
4. Document & summarize important changes from all commits since the last
release into the changelog.
5. Create a new calibration MicroSD card image for each of: 4K12 COLOUR,
MONO, Q12 COLOUR, MONO (soon).
6. Update documentation according to updates.
    1. User Guide for production must be updated and inline.
    2. Documentation regarding deployment updated if needed.
    3. Documentation for building project & dependencies kept updated.
    4. Document changes to systemd services & cron jobs that could change
       how things previously worked.
7. Create release notes from the changelog.
8. Update semantic versioning number.
9. publish documentation.
10. deploy new software version to calibration workstation.
    1. create a backup of old version.

---
