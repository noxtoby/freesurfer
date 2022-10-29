# Generated by: Neurodocker version 0.7.0+15.ga4940e3.dirty
# Latest release: Neurodocker version 0.7.0
# 
# Thank you for using Neurodocker. If you discover any issues
# or ways to improve this software, please submit an issue or
# pull request on our GitHub repository:
# 
#     https://github.com/ReproNim/neurodocker
# 
# Timestamp: 2021/06/06 14:03:44 UTC

FROM ubuntu:xenial

USER root

ARG DEBIAN_FRONTEND="noninteractive"

# LANG must not be UTF because it messes with MNI tools (perl pre-5.18.0 doesn't like UTF): https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferSegmentation
# ENV LANG="en_US.UTF-8" \
#     LC_ALL="en_US.UTF-8" \
#     ND_ENTRYPOINT="/neurodocker/startup.sh"
ENV LANG="C" \
    LC_ALL="C" \
    ND_ENTRYPOINT="/neurodocker/startup.sh"
RUN export ND_ENTRYPOINT="/neurodocker/startup.sh" \
    && apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           apt-utils \
           bzip2 \
           ca-certificates \
           curl \
           locales \
           unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e 's/# C en_US en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG="C" \
    && chmod 777 /opt && chmod a+s /opt \
    && mkdir -p /neurodocker \
    && if [ ! -f "$ND_ENTRYPOINT" ]; then \
         echo '#!/usr/bin/env bash' >> "$ND_ENTRYPOINT" \
    &&   echo 'set -e' >> "$ND_ENTRYPOINT" \
    &&   echo 'export USER="${USER:=`whoami`}"' >> "$ND_ENTRYPOINT" \
    &&   echo 'if [ -n "$1" ]; then "$@"; else /usr/bin/env bash; fi' >> "$ND_ENTRYPOINT"; \
    fi \
    && chmod -R 777 /neurodocker && chmod a+s /neurodocker

ENTRYPOINT ["/neurodocker/startup.sh"]

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           tcsh \
           bc \
           tar \
           libgomp1 \
           perl-modules \
           wget \
           curl \
           libsm-dev \
           libx11-dev \
           libxt-dev \
           libxext-dev \
           libglu1-mesa \
           libpython2.7-stdlib \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV FREESURFER_HOME="/opt/freesurfer" \
    PATH="/opt/freesurfer/bin:$PATH"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bc \
           libgomp1 \
           libxmu6 \
           libxt6 \
           perl \
           tcsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Downloading FreeSurfer ..." \
    && mkdir -p /opt/freesurfer \
    && curl -fsSL --retry 5 ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.1/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.1.tar.gz \
    | tar -xz -C /opt/freesurfer --strip-components 1 \
         --exclude='freesurfer/average/mult-comp-cor' \
         --exclude='freesurfer/lib/cuda' \
         --exclude='freesurfer/lib/qt' \
         --exclude='freesurfer/subjects/V1_average' \
         --exclude='freesurfer/subjects/bert' \
         --exclude='freesurfer/subjects/cvs_avg35' \
         --exclude='freesurfer/subjects/cvs_avg35_inMNI152' \
         --exclude='freesurfer/subjects/fsaverage3' \
         --exclude='freesurfer/subjects/fsaverage4' \
         --exclude='freesurfer/subjects/fsaverage5' \
         --exclude='freesurfer/subjects/fsaverage6' \
         --exclude='freesurfer/subjects/fsaverage_sym' \
         --exclude='freesurfer/trctrain' \
    && sed -i '$isource "/opt/freesurfer/SetUpFreeSurfer.sh"' "$ND_ENTRYPOINT"

ENV CONDA_DIR="/opt/miniconda-latest" \
    PATH="/opt/miniconda-latest/bin:$PATH"
RUN export PATH="/opt/miniconda-latest/bin:$PATH" \
    && echo "Downloading Miniconda installer ..." \
    && conda_installer="/tmp/miniconda.sh" \
    && curl -fsSL --retry 5 -o "$conda_installer" https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash "$conda_installer" -b -p /opt/miniconda-latest \
    && rm -f "$conda_installer" \
    && conda update -yq -nbase conda \
    && conda config --system --prepend channels conda-forge \
    && conda config --system --set auto_update_conda false \
    && conda config --system --set show_channel_urls true \
    && sync && conda clean -y --all && sync \
    && conda install -y -q --name base \
           "python=3" \
           "pip" \
           "pandas" \
           "setuptools" \
    && sync && conda clean -y --all && sync \
    && bash -c "source activate base \
    &&   pip install --no-cache-dir  \
             "nibabel"" \
    && rm -rf ~/.cache/pip/* \
    && sync

RUN bash -c 'curl -sL https://deb.nodesource.com/setup_14.x | bash -'

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN bash -c 'npm install -g bids-validator@0.19.8'

ENV FSLDIR="/usr/share/fsl/5.0" \
    FSLOUTPUTTYPE="NIFTI_GZ" \
    FSLMULTIFILEQUIT="TRUE" \
    POSSUMDIR="/usr/share/fsl/5.0" \
    LD_LIBRARY_PATH="/usr/lib/fsl/5.0:" \
    FSLTCLSH="/usr/bin/tclsh" \
    FSLWISH="/usr/bin/wish"

ENV OS="Linux" \
    FS_OVERRIDE="0" \
    FIX_VERTEX_AREA="" \
    SUBJECTS_DIR="/opt/freesurfer/subjects" \
    FSF_OUTPUT_FORMAT="nii.gz" \
    MNI_DIR="/opt/freesurfer/mni" \
    LOCAL_DIR="/opt/freesurfer/local" \
    FREESURFER_HOME="/opt/freesurfer" \
    FSFAST_HOME="/opt/freesurfer/fsfast" \
    MINC_BIN_DIR="/opt/freesurfer/mni/bin" \
    MINC_LIB_DIR="/opt/freesurfer/mni/lib" \
    MNI_DATAPATH="/opt/freesurfer/mni/data" \
    FMRI_ANALYSIS_DIR="/opt/freesurfer/fsfast" \
    PERL5LIB="/opt/freesurfer/mni/share/perl5" \
    MNI_PERL5LIB="/opt/freesurfer/mni/share/perl5/" \
    PATH="/opt/miniconda-latest/bin:/opt/freesurfer/bin:/opt/freesurfer/fsfast/bin:/opt/freesurfer/tktools:/opt/freesurfer/mni/bin:/usr/lib/fsl/5.0:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    PYTHONPATH=""

RUN mkdir root/matlab && touch root/matlab/startup.m

RUN mkdir /scratch

RUN mkdir /local-scratch

COPY ["run.py", "/run.py"]

RUN chmod +x /run.py

COPY ["version", "/version"]

ENTRYPOINT ["/neurodocker/startup.sh", "/run.py"]

RUN echo '{ \
    \n  "pkg_manager": "apt", \
    \n  "instructions": [ \
    \n    [ \
    \n      "base", \
    \n      "ubuntu:xenial" \
    \n    ], \
    \n    [ \
    \n      "install", \
    \n      [ \
    \n        "tcsh", \
    \n        "bc", \
    \n        "tar", \
    \n        "libgomp1", \
    \n        "perl-modules", \
    \n        "wget", \
    \n        "curl", \
    \n        "libsm-dev", \
    \n        "libx11-dev", \
    \n        "libxt-dev", \
    \n        "libxext-dev", \
    \n        "libglu1-mesa", \
    \n        "libpython2.7-stdlib" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "freesurfer", \
    \n      { \
    \n        "version": "6.0.1", \
    \n        "install_path": "/opt/freesurfer" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "miniconda", \
    \n      { \
    \n        "use_env": "base", \
    \n        "conda_install": [ \
    \n          "python=3", \
    \n          "pip", \
    \n          "pandas", \
    \n          "setuptools", \
    \n          "pandas=0.21.0" \
    \n        ], \
    \n        "pip_install": [ \
    \n          "nibabel" \
    \n        ] \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "run_bash", \
    \n      "curl -sL https://deb.nodesource.com/setup_14.x | bash -" \
    \n    ], \
    \n    [ \
    \n      "install", \
    \n      [ \
    \n        "nodejs" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "run_bash", \
    \n      "npm install -g bids-validator@0.19.8" \
    \n    ], \
    \n    [ \
    \n      "env", \
    \n      { \
    \n        "FSLDIR": "/usr/share/fsl/5.0", \
    \n        "FSLOUTPUTTYPE": "NIFTI_GZ", \
    \n        "FSLMULTIFILEQUIT": "TRUE", \
    \n        "POSSUMDIR": "/usr/share/fsl/5.0", \
    \n        "LD_LIBRARY_PATH": "/usr/lib/fsl/5.0:", \
    \n        "FSLTCLSH": "/usr/bin/tclsh", \
    \n        "FSLWISH": "/usr/bin/wish" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "env", \
    \n      { \
    \n        "OS": "Linux", \
    \n        "FS_OVERRIDE": "0", \
    \n        "FIX_VERTEX_AREA": "", \
    \n        "SUBJECTS_DIR": "/opt/freesurfer/subjects", \
    \n        "FSF_OUTPUT_FORMAT": "nii.gz", \
    \n        "MNI_DIR": "/opt/freesurfer/mni", \
    \n        "LOCAL_DIR": "/opt/freesurfer/local", \
    \n        "FREESURFER_HOME": "/opt/freesurfer", \
    \n        "FSFAST_HOME": "/opt/freesurfer/fsfast", \
    \n        "MINC_BIN_DIR": "/opt/freesurfer/mni/bin", \
    \n        "MINC_LIB_DIR": "/opt/freesurfer/mni/lib", \
    \n        "MNI_DATAPATH": "/opt/freesurfer/mni/data", \
    \n        "FMRI_ANALYSIS_DIR": "/opt/freesurfer/fsfast", \
    \n        "PERL5LIB": "/opt/freesurfer/mni/share/perl5", \
    \n        "MNI_PERL5LIB": "/opt/freesurfer/mni/share/perl5/", \
    \n        "PATH": "/opt/miniconda-latest/bin:/opt/freesurfer/bin:/opt/freesurfer/fsfast/bin:/opt/freesurfer/tktools:/opt/freesurfer/mni/bin:/usr/lib/fsl/5.0:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin", \
    \n        "PYTHONPATH": "" \
    \n      } \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "mkdir root/matlab && touch root/matlab/startup.m" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "mkdir /scratch" \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "mkdir /local-scratch" \
    \n    ], \
    \n    [ \
    \n      "copy", \
    \n      [ \
    \n        "run.py", \
    \n        "/run.py" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "run", \
    \n      "chmod +x /run.py" \
    \n    ], \
    \n    [ \
    \n      "copy", \
    \n      [ \
    \n        "version", \
    \n        "/version" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "entrypoint", \
    \n      "/neurodocker/startup.sh /run.py" \
    \n    ] \
    \n  ] \
    \n}' > /neurodocker/neurodocker_specs.json
