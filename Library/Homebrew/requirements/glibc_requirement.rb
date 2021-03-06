require "os/linux/glibc"
require "requirement"

class GlibcRequirement < Requirement
  fatal true

  def self.system_version
    OS::Linux::Glibc.system_version
  end

  # The minimum version of glibc required to use Linuxbrew bottles.
  def min_version
    Formula["glibc"].version
  rescue FormulaUnavailableError
    Version::NULL
  end

  satisfy(build_env: false) do
    next true unless OS.linux?
    next true if min_version.null?
    Formula["glibc"].installed? || OS::Linux::Glibc.system_version >= min_version
  end

  def message
    <<~EOS
      glibc #{min_version} is required to install this formula. To install it, run:
        brew install glibc
    EOS
  end
end
