base:
  'roles:devenvironment':
    - match: grain
    - devenvironment
    - devenvironment.postgres
    - devenvironment.rvm
    - devenvironment.desksnearme
    - common
  'roles:gitserver':
    - match: grain
    - gitserver
    - common
