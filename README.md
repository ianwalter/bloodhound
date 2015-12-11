# Bloodhound [![Build Status](https://semaphoreci.com/api/v1/projects/fa1c4a2b-05b4-422e-8365-0875cc386dd4/598201/shields_badge.svg)](https://semaphoreci.com/ianwalter/bloodhound)

**An ElasticSearch library for Elixir that can be easily integrated with Ecto**

## Installation

Bloodhound is [available in Hex](https://hex.pm/packages/bloodhound), the
package can be installed as:

  1. Add bloodhound to your list of dependencies in `mix.exs`:

        def deps do
          [{:bloodhound, "~> 0.1.1"}]
        end

  2. Ensure bloodhound is started before your application:

        def application do
          [applications: [:bloodhound]]
        end
