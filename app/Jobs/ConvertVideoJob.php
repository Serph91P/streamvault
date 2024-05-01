<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class ConvertVideoJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $sourcePath;

    /**
     * Create a new job instance.
     *
     * @param string $sourcePath
     */
    public function __construct(string $sourcePath)
    {
        $this->sourcePath = $sourcePath;
    }

    /**
     * Execute the job.
     */
    public function handle()
    {
        $destinationPath = preg_replace('/\.ts$/', '.mp4', $this->sourcePath);
        $ffmpegCommand = "ffmpeg -i {$this->sourcePath} -acodec copy -vcodec copy {$destinationPath}";
        shell_exec($ffmpegCommand);
    }
}
