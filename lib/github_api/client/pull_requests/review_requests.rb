# encoding: utf-8

require_relative '../../api'

module Github
  class Client::PullRequests::ReviewRequests < API
    PREVIEW_MEDIA = "application/vnd.github.symmetra-preview+json".freeze # :nodoc:

    # List review requests on a pull request
    #
    # @example
    #   github = Github.new
    #   github.pull_requests.review_requests.list 'user-name', 'repo-name', number: 'pull-request-number'
    #
    # List pull request review requests in a repository
    #
    # @example
    #   github = Github.new
    #   github.pull_requests.review_requests.list 'user-name', 'repo-name', number: 'pull-request-number'
    #   github.pull_requests.review_requests.list 'user-name', 'repo-name', number: 'pull-request-number' { |comm| ... }
    #
    # @api public
    def list(*args)
      arguments(args, required: [:user, :repo, :number])
      params = arguments.params

      params["accept"] ||= PREVIEW_MEDIA

      response = get_request("/repos/#{arguments.user}/#{arguments.repo}/pulls/#{arguments.number}/requested_reviewers", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias_method :all, :list

    # Create a pull request review request
    #
    # @param [Hash] params
    # @option params [Array] :team_reviewers
    #   An array of team slugs that will be requested.
    # @option params [Array] :reviewers
    #   An array of user logins that will be requested.
    #
    # @example
    #  github = Github.new
    #  github.pull_requests.review_requests.create 'user-name', 'repo-name', 'number',
    #   "reviewers": [
    #     "octocat",
    #     "hubot",
    #     "other_user"
    #   ],
    #   "team_reviewers": [
    #     "justice-league"
    #   ]
    #
    # @api public
    def create(*args)
      arguments(args, required: [:user, :repo, :number, :reviewers, :team_reviewers])

      params             = arguments.params
      params["accept"] ||= PREVIEW_MEDIA

      post_request("/repos/#{arguments.user}/#{arguments.repo}/pulls/#{arguments.number}/requested_reviewers", params)
    end

    # Delete a review request
    #
    # @param [Hash] params
    # @option params [Array] :team_reviewers
    #   An array of team slugs that will be removed
    # @option params [Array] :reviewers
    #   An array of user logins that will be removed
    #
    # = Examples
    #  github = Github.new
    #  github.pull_requests.review_requests.delete 'owner-name', 'repo-name', 'number'
    #   "reviewers": [
    #     "octocat",
    #     "hubot",
    #     "other_user"
    #   ],
    #   "team_reviewers": [
    #     "justice-league"
    #   ]
    #
    # @api public
    def delete(*args)
      arguments(args, required: [:user, :repo, :number, :reviewers, :team_reviewers])

      delete_request("/repos/#{arguments.user}/#{arguments.repo}/pulls/#{arguments.number}/requested_reviewers", arguments.params)
    end
  end
end
