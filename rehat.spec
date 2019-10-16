Name:           rehat
Version:        0.1.0
Release:        1%{?dist}
Summary:        Simple GTK Rest Client

License:        MIT
URL:            https://github.com/showcheap/rehat
Source0:        https://github.com/showcheap/rehat/archive/%{version}.tar.gz

BuildRequires:  meson vala gtk3-devel json-glib-devel libsoup-devel gtksourceview4-devel
Requires:	gtk3 libsoup json-glib gtksourceview4

%description
GTK REST Client

%prep
%autosetup -n %{name}-%{version}


%build
%meson
%meson_build

%install
%meson_install

%files
%{_bindir}/rehat
%{_datadir}/appdata/id.sucipto.rehat.appdata.xml
%{_datadir}/applications/id.sucipto.rehat.desktop
%{_datadir}/glib-2.0/schemas/id.sucipto.rehat.gschema.xml


%changelog
* Mon Oct 16 2019 Sucipto <hi@sucipto.id>
- Add spec file

