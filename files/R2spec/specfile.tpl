# This spec file generated for EuPathDB customized R2spec template

%global packname  {{ packname }}
{% if (arch == False) %}%global rlibdir  %{_datadir}/R/library
{% else %}%global rlibdir  %{_libdir}/R/library
{% endif %}

Name:             R-%{packname}
Version:          {{version}}
Release:          1%{?dist}
Summary:          {{summary}}

Group:            Applications/Engineering 
License:          {{license}}
URL:              {{URL}}
Source0:          {{source0}}
BuildRoot:        %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

# Here's the R view of the dependencies world:
# Depends:   {{depends}}
# Imports:   {{imports}}
# Suggests:  {{suggests}}
# LinkingTo:
# Enhances:

{% if (arch == False) %}BuildArch:        noarch
Requires:         R-core
{% endif %}
{% if depends != "" %}Requires:         {{depends}} {% endif %}
{% if imports != "" %}Requires:         {{imports}} {% endif %}
{% if suggests != "" %}Requires:         {{suggests}} {% endif %}
BuildRequires:    R-devel tex(latex) {{depends}}
{% if imports != "" %}BuildRequires:    {{imports}} {% endif %}
{% if suggests != "" %}BuildRequires:   {{suggests}} {% endif %}

%description
{{description}}

%prep
%setup -q -c -n %{packname}

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{rlibdir}
%{_bindir}/R CMD INSTALL -l %{buildroot}%{rlibdir} %{packname}
test -d %{packname}/src && (cd %{packname}/src; rm -f *.o *.so)
rm -f %{buildroot}%{rlibdir}/R.css
{% if (no_check == False) %}
%check
%{_bindir}/R CMD check %{packname}
{% endif %}

# EuPathDB custom
find %{buildroot}%{rlibdir}/%{packname} -type d -name unitTests -print0 | xargs -0 rm -rf --
find %{buildroot}%{rlibdir}/%{packname} -type d -name tests -print0 | xargs -0 rm -rf --
find %{buildroot}%{rlibdir}/%{packname} -type d -name demo -print0 | xargs -0 rm -rf --
find %{buildroot}%{rlibdir}/%{packname} -type d -name examples -print0 | xargs -0 rm -rf --
# Patch files that may contain build_root (detected by check-buildroot script), the grep excludes binary files
find %{buildroot} -type f -exec grep -Il . {} \; | xargs sed -i "s|%{buildroot}||g"
find %{buildroot} -type f | sed "s|%{buildroot}||" | tee filelist

%clean
rm -rf %{buildroot}

%files -f filelist

%changelog
* {{date}} {{name}} <{{email}}> {{version}}-1
- initial package for CentOS
