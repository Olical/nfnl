(local {: autoload : define} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local str (autoload :nfnl.string))
(local fs (autoload :nfnl.fs))

(local M (define :nfnl.gc))

(fn M.find-orphan-lua-files [{: cfg : root-dir}]
  (let [fnl-path->lua-path (cfg [:fnl-path->lua-path])]
    (->> (cfg [:source-file-patterns])
         (core.mapcat
           (fn [fnl-pattern]
             (let [lua-pattern (fnl-path->lua-path fnl-pattern)]
               (fs.absglob root-dir lua-pattern))))
         (core.->set)
         (core.keys)
         (core.filter
           (fn [path]
             ;; TODO This needs to share code with nfnl.compile.
             ;; TODO Need to check if the header matches our pattern of [nfnl] file-path
             (let [header (fs.read-first-line path)]
               (and header
                    (not (core.nil? (header:find "[nfnl]" 1 true)))
                    (not (vim.uv.fs_stat (core.last (str.split path "%s+")))))))))))

(comment
  (local config (require :nfnl.config))
  (M.find-orphan-lua-files (config.find-and-load ".")))

M
