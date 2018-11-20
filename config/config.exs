use Mix.Config

if Mix.env() == :test do
  config :clamex, scanner: Clamex.Scanner.Mock
else
  config :clamex, scanner: Clamex.Scanner.Clamdscan
end
