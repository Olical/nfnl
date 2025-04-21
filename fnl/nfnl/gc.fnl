(local {: autoload : define} (require :nfnl.module))
(local core (autoload :nfnl.core))
(local fs (autoload :nfnl.fs))
(local header (autoload :nfnl.header))

(local M (define :nfnl.gc))

(fn M.find-orphan-lua-files [{: cfg : root-dir}]
  (let [fnl-path->lua-path (cfg [:fnl-path->lua-path])]
    (->> (cfg [:source-file-patterns])
         (core.mapcat
           (fn [fnl-pattern]
             (let [lua-pattern (fnl-path->lua-path fnl-pattern)]
               (fs.relglob root-dir lua-pattern))))
         (core.->set)
         (core.keys)
         (core.filter
           (fn [path]
             (let [line (fs.read-first-line path)]
               (and (header.tagged? line)
                    (not (fs.exists? (header.source-path line))))))))))

(comment
  (local config (require :nfnl.config))
  (M.find-orphan-lua-files (config.find-and-load ".")))

M
