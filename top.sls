base:
  'roles:devenvironment':
    - match: grain
    - common
    - devenvironment
    - devenvironment.postgres
    - devenvironment.rvm
    - devenvironment.desksnearme
  'roles:gitserver':
    - match: grain
    - common
    - gitserver
