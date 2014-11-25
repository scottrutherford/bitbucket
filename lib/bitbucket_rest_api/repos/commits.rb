# encoding: utf-8

module BitBucket
  class Repos::Commits < API

    REQUIRED_COMMENT_PARAMS = %w[
        body
        commit_id
        line
        path
        position
      ].freeze

    # List commits on a repository
    #
    # = Parameters
    # * <tt>:include</tt>
    # * <tt>:exclude</tt>
    #
    # = Examples
    #  bitbucket = BitBucket.new
    #  bitbucket.repos.commits.list 'user-name', 'repo-name', include: feature
    #  bitbucket.repos.commits.list 'user-name', 'repo-name', exclude: master
    #
    def list(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params
      filter! %w[include exclude], params

      response = get_request("/repositories/#{user}/#{repo.downcase}/commits", params)
      return response unless block_given?
      response.each { |el| yield el }
    end
    alias :all :list

    # Gets a single commit
    #
    # = Examples
    #  @bitbucket = BitBucket.new
    #  @bitbucket.repos.commits.get 'user-name', 'repo-name', '6dcb09b5b57875f334f61aebed6')
    #
    def get(user_name, repo_name, sha, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      _validate_presence_of sha
      normalize! params

      get_request("/repositories/#{user}/#{repo.downcase}/commit/#{sha}", params)
    end
    alias :find :get

  end # Repos::Commits
end # BitBucket